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

/// Generate entropy that is guaranteed to be translatable into an HDPrivateKey
public func generateEntropyForHDKey(network: Network) -> Data {
    var seed: Data!
    repeat {
        seed = Bitcoin.seed(bits: 256)
        do {
            _ = try seed |> newHDPrivateKey(network: network)
        } catch {
            seed = nil
        }
    } while seed == nil
    return seed
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
        return try privateKey.rawValue.withCString { privateKeyString in
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
public func deriveHDPublicKey(isHardened: Bool, index: Int, network: Network = .mainnet) -> (_ key: HDKey) throws -> HDKey {
    return { parentKey in
        return try parentKey.rawValue.withCString { parentKeyString in
            var childPublicKey: UnsafeMutablePointer<Int8>!
            var childPublicKeyLength = 0
            if let error = BitcoinError(rawValue: _deriveHDPublicKey(parentKeyString, index, isHardened, network.hdKeyPublicVersion, network.hdKeyPrivateVersion, &childPublicKey, &childPublicKeyLength)) {
                throw error
            }
            return receiveString(bytes: childPublicKey, count: childPublicKeyLength) |> tagHDKey
        }
    }
}

/// Derive the HD (BIP32) public key of a HD private key.
public func toHDPublicKey(network: Network) -> (_ privateKey: HDKey) throws -> HDKey {
    return { privateKey in
        return try privateKey.rawValue.withCString { privateKeyString in
            var publicKey: UnsafeMutablePointer<Int8>!
            var publicKeyLength = 0
            if let error = BitcoinError(rawValue: _toHDPublicKey(privateKeyString, network.hdKeyPublicVersion, &publicKey, &publicKeyLength)) {
                throw error
            }
            return receiveString(bytes: publicKey, count: publicKeyLength) |> tagHDKey
        }
    }
}

/// Convert a HD (BIP32) public or private key to the equivalent EC public or private key.
public func toECKey(network: Network) -> (_ hdKey: HDKey) throws -> ECKey {
    return { hdKey in
        try hdKey.rawValue.withCString { hdKeyString in
            var ecKey: UnsafeMutablePointer<UInt8>!
            var ecKeyLength = 0
            var isPrivate = false
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
}

/// Derives an "account private key" from the given master key, per BIP-0044:
///
/// Performs the the derviation in brackets below:
///
/// `[ m / purpose' / coin_type' / account' ]`
public func deriveAccountKey(masterKey: HDKey, coinType: CoinType, network: Network, accountID: Int) throws -> HDKey {
    let purposeKey = try masterKey |> deriveHDPrivateKey(isHardened: true, index: 44)
    let coinTypeKey = try purposeKey |> deriveHDPrivateKey(isHardened: true, index: CoinType.index(for: coinType, network: network))
    let accountKey = try coinTypeKey |> deriveHDPrivateKey(isHardened: true, index: accountID)
    return accountKey
}

/// Derives an "address private key" from the given account key, per BIP-0044:
///
/// Performs the part of the derviation in brackets below:
///
/// `m / purpose' / coin_type' / account' [ / change / address_index ]`
public func deriveAddressKey(accountKey: HDKey, chainType: ChainType, addressIndex: Int) throws -> HDKey {
    let chainKey = try accountKey |> deriveHDPrivateKey(isHardened: false, index: chainType.rawValue)
    let addressKey = try chainKey |> deriveHDPrivateKey(isHardened: false, index: addressIndex)
    return addressKey
}
