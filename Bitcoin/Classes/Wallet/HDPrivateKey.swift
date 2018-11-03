//
//  HDPrivateKey.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/30/18.
//

import CBitcoin

public var minimumSeedSize: Int = {
    return _minimumSeedSize()
}()

public enum HDPublicKeyVersion: UInt32 {
    case mainnet = 0x0488B21E
    case testnet = 0x043587CF
}

public enum HDPrivateKeyVersion: UInt32 {
    case mainnet = 0x0488ADE4
    case testnet = 0x04358394
}

/// Create a new HD (BIP32) private key from entropy.
public func newHDPrivateKey(version: HDPrivateKeyVersion) -> (_ seed: Data) throws -> String {
    return { seed in
        guard seed.count >= minimumSeedSize else {
            throw BitcoinError.seedTooSmall
        }
        var key: UnsafeMutablePointer<Int8>!
        var keyLength = 0
        let success = seed.withUnsafeBytes { (seedBytes: UnsafePointer<UInt8>) in
            _newHDPrivateKey(seedBytes, seed.count, version.rawValue, &key, &keyLength)
        }
        guard success else {
            throw BitcoinError.invalidSeed
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
            let success = _deriveHDPrivateKey(privateKeyString, index, isHardened, &childKey, &childKeyLength)
            guard success else {
                throw BitcoinError.invalidFormat
            }
            return receiveString(bytes: childKey, count: childKeyLength)
        }
    }
}

/// Derive a child HD (BIP32) public key from another HD public or private key.
public func deriveHDPublicKey(isHardened: Bool, index: Int, publicVersion: HDPublicKeyVersion = .mainnet, privateVersion: HDPrivateKeyVersion = .mainnet) -> (_ key: String) throws -> String {
    return { parentKey in
        return try parentKey.withCString { parentKeyString in
            var childPublicKey: UnsafeMutablePointer<Int8>!
            var childPublicKeyLength = 0
            if let error = BitcoinError(rawValue: _deriveHDPublicKey(parentKeyString, index, isHardened, publicVersion.rawValue, privateVersion.rawValue, &childPublicKey, &childPublicKeyLength)) {
                throw error
            }
            return receiveString(bytes: childPublicKey, count: childPublicKeyLength)
        }
    }
}
