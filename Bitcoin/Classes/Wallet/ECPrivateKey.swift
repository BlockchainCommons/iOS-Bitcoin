//
//  ECPrivateKey.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/30/18.
//

import CBitcoin
import WolfPipe

public let ecPrivateKeySize: Int = { return _ecPrivateKeySize() }()

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

/// Create a new EC private key from entropy.
public func newECPrivateKey(_ seed: Data) throws -> ECPrivateKey {
    guard seed.count >= minimumSeedSize else {
        throw BitcoinError.seedTooSmall
    }
    var privateKeyBytes: UnsafeMutablePointer<UInt8>!
    var privateKeyLength: Int = 0
    let success = seed.withUnsafeBytes { (seedBytes: UnsafePointer<UInt8>) in
        _ecNewPrivateKey(seedBytes, seed.count, &privateKeyBytes, &privateKeyLength)
    }
    guard success else {
        throw BitcoinError.invalidSeed
    }
    return try ECPrivateKey(receiveData(bytes: privateKeyBytes, count: privateKeyLength))
}
