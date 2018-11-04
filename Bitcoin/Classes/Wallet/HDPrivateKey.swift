//
//  HDPrivateKey.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/30/18.
//

import CBitcoin
import WolfPipe

public var minimumSeedSize: Int = {
    return _minimumSeedSize()
}()

//public enum HDPublicKeyVersion: UInt32 {
//    case mainnet = 0x0488B21E
//    case testnet = 0x043587CF
//}
//
//public enum HDPrivateKeyVersion: UInt32 {
//    case mainnet = 0x0488ADE4
//    case testnet = 0x04358394
//}

public enum HDKeyVersion {
    case mainnet
    case testnet

    public var publicVersion: UInt32 {
        switch self {
        case .mainnet:
            return 0x0488B21E
        case .testnet:
            return 0x043587CF
        }
    }

    public var privateVersion: UInt32 {
        switch self {
        case .mainnet:
            return 0x0488ADE4
        case .testnet:
            return 0x04358394
        }
    }
}

/// Create a new HD (BIP32) private key from entropy.
public func newHDPrivateKey(version: HDKeyVersion) -> (_ seed: Data) throws -> String {
    return { seed in
        var key: UnsafeMutablePointer<Int8>!
        var keyLength = 0
        try seed.withUnsafeBytes { (seedBytes: UnsafePointer<UInt8>) in
            if let error = BitcoinError(rawValue: _newHDPrivateKey(seedBytes, seed.count, version.privateVersion, &key, &keyLength)) {
                throw error
            }
        }
        return receiveString(bytes: key, count: keyLength)
    }
}

/// Derive a child HD (BIP32) private key from another HD private key.
public func deriveHDPrivateKey(isHardened: Bool, index: Int) -> (_ privateKey: String) throws -> String {
    return { privateKey in
        return try privateKey.withCString { privateKeyString in
            var childKey: UnsafeMutablePointer<Int8>!
            var childKeyLength = 0
            if let error = BitcoinError(rawValue: _deriveHDPrivateKey(privateKeyString, index, isHardened, &childKey, &childKeyLength)) {
                throw error
            }
            return receiveString(bytes: childKey, count: childKeyLength)
        }
    }
}

/// Derive a child HD (BIP32) public key from another HD public or private key.
public func deriveHDPublicKey(isHardened: Bool, index: Int, version: HDKeyVersion = .mainnet) -> (_ key: String) throws -> String {
    return { parentKey in
        return try parentKey.withCString { parentKeyString in
            var childPublicKey: UnsafeMutablePointer<Int8>!
            var childPublicKeyLength = 0
            if let error = BitcoinError(rawValue: _deriveHDPublicKey(parentKeyString, index, isHardened, version.publicVersion, version.privateVersion, &childPublicKey, &childPublicKeyLength)) {
                throw error
            }
            return receiveString(bytes: childPublicKey, count: childPublicKeyLength)
        }
    }
}

/// Derive the HD (BIP32) public key of a HD private key.
public func toHDPublicKey(version: HDKeyVersion) -> (_ privateKey: String) throws -> String {
    return { privateKey in
        return try privateKey.withCString { privateKeyString in
            var publicKey: UnsafeMutablePointer<Int8>!
            var publicKeyLength = 0
            if let error = BitcoinError(rawValue: _toHDPublicKey(privateKeyString, version.publicVersion, &publicKey, &publicKeyLength)) {
                throw error
            }
            return receiveString(bytes: publicKey, count: publicKeyLength)
        }
    }
}

/// Derive the HD (BIP32) public key of a HD private key.
public func toHDPublicKey(_ privateKey: String) throws -> String {
    return try privateKey |> toHDPublicKey(version: .mainnet)
}
