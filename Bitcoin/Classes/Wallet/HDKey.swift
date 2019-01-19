//
//  HDKey.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/30/18.
//
//  Copyright © 2018 Blockchain Commons.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

import CBitcoin
import WolfPipe
import WolfFoundation

public enum HDKeyTag { }
public typealias HDKey = Tagged<HDKeyTag, String>

public func tagHDKey(_ string: String) -> HDKey { return HDKey(rawValue: string) }

public var minimumSeedSize: Int = {
    return _minimumSeedSize()
}()

extension Network {
    public var hdKeyPublicVersion: UInt32 {
        switch self {
        case .mainnet:
            return 0x0488B21E
        case .testnet:
            return 0x043587CF
        }
    }

    public var hdKeyPrivateVersion: UInt32 {
        switch self {
        case .mainnet:
            return 0x0488ADE4
        case .testnet:
            return 0x04358394
        }
    }
}

public func generateEntropyForHDKey() -> Data {
    return Bitcoin.seed(bits: 256)
}

/// Create a new HD (BIP32) private key from entropy.
public func newHDPrivateKey(network: Network) -> (_ seed: Data) throws -> HDKey {
    return { seed in
        var key: UnsafeMutablePointer<Int8>!
        var keyLength = 0
        try seed.withUnsafeBytes { (seedBytes: UnsafePointer<UInt8>) in
            if let error = BitcoinError(rawValue: _newHDPrivateKey(seedBytes, seed.count, network.hdKeyPrivateVersion, &key, &keyLength)) {
                throw error
            }
        }
        return receiveString(bytes: key, count: keyLength) |> tagHDKey
    }
}

/// Derive a child HD (BIP32) private key from another HD private key.
public func deriveHDPrivateKey(isHardened: Bool, index: Int) -> (_ privateKey: HDKey) throws -> HDKey {
    return { privateKey in
        return try privateKey®.withCString { privateKeyString in
            var childKey: UnsafeMutablePointer<Int8>!
            var childKeyLength = 0
            if let error = BitcoinError(rawValue: _deriveHDPrivateKey(privateKeyString, index, isHardened, &childKey, &childKeyLength)) {
                throw error
            }
            return receiveString(bytes: childKey, count: childKeyLength) |> tagHDKey
        }
    }
}

/// Derive a child HD (BIP32) public key from another HD public or private key.
public func deriveHDPublicKey(isHardened: Bool, index: Int) -> (_ parentKey: HDKey) throws -> HDKey {
    return { parentKey in
        return try parentKey®.withCString { parentKeyString in
            var childPublicKey: UnsafeMutablePointer<Int8>!
            var childPublicKeyLength = 0
            let network = parentKey |> Bitcoin.network
            if let error = BitcoinError(rawValue: _deriveHDPublicKey(parentKeyString, index, isHardened, network.hdKeyPublicVersion, network.hdKeyPrivateVersion, &childPublicKey, &childPublicKeyLength)) {
                throw error
            }
            return receiveString(bytes: childPublicKey, count: childPublicKeyLength) |> tagHDKey
        }
    }
}

/// Derive the HD (BIP32) public key of a HD private key.
public func toHDPublicKey(_ privateKey: HDKey) throws -> HDKey {
    return try privateKey®.withCString { privateKeyString in
        var publicKey: UnsafeMutablePointer<Int8>!
        var publicKeyLength = 0
        let network = privateKey |> Bitcoin.network
        if let error = BitcoinError(rawValue: _toHDPublicKey(privateKeyString, network.hdKeyPublicVersion, &publicKey, &publicKeyLength)) {
            throw error
        }
        return receiveString(bytes: publicKey, count: publicKeyLength) |> tagHDKey
    }
}

/// Convert a HD (BIP32) public or private key to the equivalent EC public or private key.
public func toECKey(_ hdKey: HDKey) throws -> ECKey {
    return try hdKey®.withCString { hdKeyString in
        var ecKey: UnsafeMutablePointer<UInt8>!
        var ecKeyLength = 0
        var isPrivate = false
        let network = hdKey |> Bitcoin.network
        if let error = BitcoinError(rawValue: _toECKey(hdKeyString, network.hdKeyPublicVersion, network.hdKeyPrivateVersion, &isPrivate, &ecKey, &ecKeyLength)) {
            throw error
        }
        let data = receiveData(bytes: ecKey, count: ecKeyLength)
        switch isPrivate {
        case true:
            return try ECPrivateKey(data)
        case false:
            return try ECCompressedPublicKey(data)
        }
    }
}

public enum HDKeyPurpose: Int {
    case defaultAccount = 0 // BIP32
    case accountTree = 44 // BIP44
    case multisig = 45 // BIP45
}

/// Derives an "account private key" from the given master key, per BIP-0044:
///
/// Performs the the derviation in brackets below:
///
/// `[ m / purpose' / coin_type' / account' ]`
public func deriveHDAccountPrivateKey(coinType: CoinType, accountIndex: Int) -> (_ masterKey: HDKey) throws -> HDKey {
    return { masterKey in
        let network = masterKey |> Bitcoin.network
        let purposeKey = try masterKey |> deriveHDPrivateKey(isHardened: true, index: HDKeyPurpose.accountTree®)
        let coinTypeKey = try purposeKey |> deriveHDPrivateKey(isHardened: true, index: CoinType.index(for: coinType, network: network))
        let accountKey = try coinTypeKey |> deriveHDPrivateKey(isHardened: true, index: accountIndex)
        return accountKey
    }
}

/// Derives an "address private key" from the given account key, per BIP-0044:
///
/// Performs the part of the derviation in brackets below:
///
/// `m / purpose' / coin_type' / account' [ / change / address_index ]`
public func deriveHDAddressPrivateKey(chainType: ChainType, addressIndex: Int) -> (_ accountKey: HDKey) throws -> HDKey {
    return { accountKey in
        let chainKey = try accountKey |> deriveHDPrivateKey(isHardened: false, index: chainType®)
        let addressKey = try chainKey |> deriveHDPrivateKey(isHardened: false, index: addressIndex)
        return addressKey
    }
}

/// Derives an "address public key" from the given account key, per BIP-0044:
///
/// Performs the part of the derviation in brackets below:
///
/// `m / purpose' / coin_type' / account' [ / change / address_index ]`
public func deriveHDAddressPublicKey(chainType: ChainType, addressIndex: Int) -> (_ accountKey: HDKey) throws -> HDKey {
    return { accountKey in
        let chainKey = try accountKey |> deriveHDPublicKey(isHardened: false, index: chainType®)
        let addressKey = try chainKey |> deriveHDPublicKey(isHardened: false, index: addressIndex)
        return addressKey
    }
}

public func prefix(_ hdKey: HDKey) -> String {
    return String(hdKey®.prefix(4))
}

public func network(_ hdKey: HDKey) -> Network {
    let s = (hdKey |> prefix).first!
    switch s {
    case "x":
        return .mainnet
    case "t":
        return .testnet
    default:
        fatalError()
    }
}

public func isPrivate(_ hdKey: HDKey) -> Bool {
    let s = String((hdKey |> prefix).dropFirst())
    switch s {
    case "pub":
        return false
    case "prv":
        return true
    default:
        fatalError()
    }
}

public func isPublic(_ hdKey: HDKey) -> Bool {
    return !(hdKey |> isPrivate)
}
