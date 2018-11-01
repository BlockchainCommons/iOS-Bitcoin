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

/// Create a new HD (BIP32) private key from entropy.
public func hdNew(version: UInt32) -> (_ seed: Data) throws -> String {
    return { seed in
        guard seed.count >= minimumSeedSize else {
            throw BitcoinError.seedTooSmall
        }
        var key: UnsafeMutablePointer<Int8>!
        var keyLength: Int = 0
        let success = seed.withUnsafeBytes { (seedBytes: UnsafePointer<UInt8>) in
            _hdNew(seedBytes, seed.count, version, &key, &keyLength)
        }
        guard success else {
            throw BitcoinError.invalidSeed
        }
        return receiveString(bytes: key, count: keyLength)
    }
}
