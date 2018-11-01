//
//  ECNew.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/30/18.
//

import CBitcoin
import WolfPipe

public let ecPrivateKeySize: Int = { return _ecPrivateKeySize() }()
public let ecPublicKeySize: Int = { return _ecPublicKeySize() }()
public let ecUncompressedPublicKeySize: Int = { return _ecUncompressedPublicKeySize() }()

public struct ECPrivateKey {
    public let data: Data

    public init(_ data: Data) throws {
        guard data.count == ecPrivateKeySize else {
            throw BitcoinError.invalidDataSize
        }
        self.data = data
    }
}

public func toECPrivateKey(_ data: Data) throws -> ECPrivateKey {
    return try ECPrivateKey(data)
}

public func base16Encode(_ privateKey: ECPrivateKey) -> String {
    return privateKey.data |> base16Encode
}

public struct ECPublicKey {
    public let data: Data

    public init(_ data: Data) throws {
        guard data.count == ecPublicKeySize else {
            throw BitcoinError.invalidDataSize
        }
        self.data = data
    }
}

public func toECPublicKey(_ data: Data) throws -> ECPublicKey {
    return try ECPublicKey(data)
}

public func base16Encode(_ publicKey: ECPublicKey) -> String {
    return publicKey.data |> base16Encode
}

public struct ECUncompressedPublicKey {
    public let data: Data

    public init(_ data: Data) throws {
        guard data.count == ecUncompressedPublicKeySize else {
            throw BitcoinError.invalidDataSize
        }
        self.data = data
    }
}

public func toECUncompressedPublicKey(_ data: Data) throws -> ECUncompressedPublicKey {
    return try ECUncompressedPublicKey(data)
}

public func base16Encode(_ publicKey: ECUncompressedPublicKey) -> String {
    return publicKey.data |> base16Encode
}

/// Create a new EC private key from entropy.
public func ecNew(_ seed: Data) throws -> ECPrivateKey {
    guard seed.count >= minimumSeedSize else {
        throw BitcoinError.seedTooSmall
    }
    var privateKeyBytes: UnsafeMutablePointer<UInt8>!
    var privateKeyLength: Int = 0
    let success = seed.withUnsafeBytes { (seedBytes: UnsafePointer<UInt8>) in
        _ecNew(seedBytes, seed.count, &privateKeyBytes, &privateKeyLength)
    }
    guard success else {
        throw BitcoinError.invalidSeed
    }
    return try ECPrivateKey(receiveData(bytes: privateKeyBytes, count: privateKeyLength))
}

/// Derive the compressed EC public key of an EC private key.
///
/// This is a single-argument function suitable for use with the pipe operator.
public func toECPublicKey(_ privateKey: ECPrivateKey) -> ECPublicKey {
    return privateKey.data.withUnsafeBytes { (privateKeyBytes: UnsafePointer<UInt8>) in
        var publicKeyBytes: UnsafeMutablePointer<UInt8>!
        var publicKeyLength: Int = 0
        _ = _ecToPublic(privateKeyBytes, privateKey.data.count, &publicKeyBytes, &publicKeyLength)
        return try! ECPublicKey(receiveData(bytes: publicKeyBytes, count: publicKeyLength))
    }
}

/// Derive the uncompressed EC public key of an EC private key.
///
/// This is a single-argument function suitable for use with the pipe operator.
public func toECUncompressedPublicKey(_ privateKey: ECPrivateKey) -> ECUncompressedPublicKey {
    return privateKey.data.withUnsafeBytes { (privateKeyBytes: UnsafePointer<UInt8>) in
        var publicKeyBytes: UnsafeMutablePointer<UInt8>!
        var publicKeyLength: Int = 0
        _ = _ecToPublicUncompressed(privateKeyBytes, privateKey.data.count, &publicKeyBytes, &publicKeyLength)
        return try! ECUncompressedPublicKey(receiveData(bytes: publicKeyBytes, count: publicKeyLength))
    }
}
