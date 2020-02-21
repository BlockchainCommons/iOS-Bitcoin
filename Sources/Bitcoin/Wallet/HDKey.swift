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
import WolfFoundation
import WolfPipe

public enum HDKeyTag { }
public typealias HDKey = Tagged<HDKeyTag, String>

public func tagHDKey(_ string: String) -> HDKey { return HDKey(rawValue: string) }

public var minimumSeedSize: Int = {
    return _minimumSeedSize()
}()

/// Create a new HD (BIP32) private key from entropy.
public func newHDPrivateKey(hdKeyVersion: HDKeyVersion) -> (_ seed: Data) throws -> HDKey {
    return { seed in
        var key: UnsafeMutablePointer<Int8>!
        var keyLength = 0
        try seed.withUnsafeBytes { seedBytes in
            if let error = BitcoinError(rawValue: _newHDPrivateKey(seedBytes®, seed.count, hdKeyVersion.privateVersion, &key, &keyLength)) {
                throw error
            }
        }
        return receiveString(bytes: key, count: keyLength) |> tagHDKey
    }
}

public func prefix(_ hdKey: HDKey) -> Base58 {
    return String(hdKey®.prefix(4)) |> tagBase58
}

public func version(_ hdKey: HDKey) throws -> HDKeyVersion {
    let pfx = hdKey |> prefix
    guard let vers = hdKeyVersions.first(where: { $0.publicPrefix == pfx || $0.privatePrefix == pfx }) else {
        throw BitcoinError.invalidFormat
    }
    return vers
}

public func network(_ hdKey: HDKey) throws -> Network {
    return try hdKey |> version |> network
}

public func isPrivate(_ hdKey: HDKey) -> Bool {
    let pfx = hdKey |> prefix
    let vers = hdKeyVersions.first { $0.privatePrefix == pfx}
    return vers != nil
}

public func isPublic(_ hdKey: HDKey) -> Bool {
    let pfx = hdKey |> prefix
    let vers = hdKeyVersions.first { $0.publicPrefix == pfx}
    return vers != nil
}

public func coinType(_ hdKey: HDKey) throws -> CoinType {
    let vers = try hdKey |> version
    return vers.coinType
}

/// Derive a child HD (BIP32) private key from another HD private key.
public func deriveHDPrivateKey(_ component: BIP32Path.Component) -> (_ privateKey: HDKey) throws -> HDKey {
    return { privateKey in
        switch component {
        case .master:
            return privateKey
        case .index(let indexComponent):
            return try privateKey®.withCString { privateKeyString in
                var childKey: UnsafeMutablePointer<Int8>!
                var childKeyLength = 0

                if let error = BitcoinError(rawValue: _deriveHDPrivateKey(privateKeyString, indexComponent.index, indexComponent.isHardened, &childKey, &childKeyLength)) {
                    throw error
                }
                return receiveString(bytes: childKey, count: childKeyLength) |> tagHDKey
            }
        }
    }
}

/// Derive a child HD (BIP32) public key from another HD public or private key.
public func deriveHDPublicKey(_ component: BIP32Path.Component) -> (_ parentKey: HDKey) throws -> HDKey {
    return { parentKey in
        switch component {
        case .master:
            return parentKey
        case .index(let indexComponent):
            return try parentKey®.withCString { parentKeyString in
                var childPublicKey: UnsafeMutablePointer<Int8>!
                var childPublicKeyLength = 0
                let vers = try parentKey |> version
                if let error = BitcoinError(rawValue: _deriveHDPublicKey(parentKeyString, indexComponent.index, indexComponent.isHardened, vers.publicVersion, vers.privateVersion, &childPublicKey, &childPublicKeyLength)) {
                    throw error
                }
                return receiveString(bytes: childPublicKey, count: childPublicKeyLength) |> tagHDKey
            }
        }
    }
}

/// Derive the HD (BIP32) public key of a HD private key.
public func toHDPublicKey(_ privateKey: HDKey) throws -> HDKey {
    return try privateKey®.withCString { privateKeyString in
        var publicKey: UnsafeMutablePointer<Int8>!
        var publicKeyLength = 0
        let vers = try privateKey |> version
        if let error = BitcoinError(rawValue: _toHDPublicKey(privateKeyString, vers.publicVersion, &publicKey, &publicKeyLength)) {
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
        let vers = try hdKey |> version
        if let error = BitcoinError(rawValue: _toECKey(hdKeyString, vers.publicVersion, vers.privateVersion, &isPrivate, &ecKey, &ecKeyLength)) {
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

/// Derives a private key according to a BIP32 derivation path.
public func deriveHDPrivateKey(path: BIP32Path) -> (_ key: HDKey) throws -> HDKey {
    return { key in
        try path.components.reduce(key) { (key, component) in
            try key |> deriveHDPrivateKey(component)
        }
    }
}

/// Derives a public key according to a BIP32 derivation path.
public func deriveHDPublicKey(path: BIP32Path) -> (_ key: HDKey) throws -> HDKey {
    return { key in
        try path.components.reduce(key) { (key, component) in
            try key |> deriveHDPublicKey(component)
        }
    }
}

/// Derives an "account private key" from the given master key, per BIP44:
///
/// Performs the the derviation in brackets below:
///
/// `m / [ purpose' / coin_type' / account' ]`
public func deriveHDAccountPrivateKey(purpose: HDKeyPurpose? = nil, accountIndex: Int) -> (_ masterKey: HDKey) throws -> HDKey {
    return { masterKey in
        let path = try hdAccountPrivateKeyDerivationPath(masterKey: masterKey, purpose: purpose, accountIndex: accountIndex)
        return try masterKey |> deriveHDPrivateKey(path: path)
    }
}

public func hdAccountPrivateKeyDerivationPath(masterKey: HDKey, purpose: HDKeyPurpose? = nil, accountIndex: Int) throws -> BIP32Path {
    let vers = try masterKey |> version
    let effectivePurpose = purpose ?? vers.purpose!
    let path: BIP32Path = [
        .master,
        .index(.init(effectivePurpose®, isHardened: true)),
        .index(.init(CoinType.index(for: vers.coinType, network: vers.network), isHardened: true)),
        .index(.init(accountIndex, isHardened: true))
    ]
    return path
}

/// Derives an "address private key" from the given account key, per BIP-0044:
///
/// Performs the part of the derviation in brackets below:
///
/// `m / purpose' / coin_type' / account' [ / chain_type / address_index ]`
public func deriveHDAddressPrivateKey(chainType: ChainType, addressIndex: Int) -> (_ accountKey: HDKey) throws -> HDKey {
    return { accountKey in
        let path = hdAddressPrivateKeyDerivationPath(chainType: chainType, addressIndex: addressIndex)
        return try accountKey |> deriveHDPrivateKey(path: path)
    }
}

public func hdAddressPrivateKeyDerivationPath(chainType: ChainType, addressIndex: Int) -> BIP32Path {
    let path: BIP32Path = [
        .index(.init(chainType®, isHardened: false)),
        .index(.init(addressIndex, isHardened: false))
    ]
    return path
}

/// Derives an "address public key" from the given account key, per BIP-0044:
///
/// Performs the part of the derviation in brackets below:
///
/// `m / purpose' / coin_type' / account' [ / chain_type / address_index ]`
public func deriveHDAddressPublicKey(chainType: ChainType, addressIndex: Int) -> (_ accountKey: HDKey) throws -> HDKey {
    return { accountKey in
        let path = hdAddressPrivateKeyDerivationPath(chainType: chainType, addressIndex: addressIndex)
        return try accountKey |> deriveHDPublicKey(path: path)
    }
}
