//
//  ECNew.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/30/18.
//

import CBitcoin

public func ecNew(_ seed: Data) throws -> Data {
    guard seed.count >= minimumSeedSize else {
        throw BitcoinError.seedTooSmall
    }
    var key: UnsafeMutablePointer<UInt8>!
    var keyLength: Int = 0
    let success = seed.withUnsafeBytes { (seedBytes: UnsafePointer<UInt8>) in
        _ecNew(seedBytes, seed.count, &key, &keyLength)
    }
    guard success else {
        throw BitcoinError.invalidSeed
    }
    return receiveData(bytes: key, count: keyLength)
}
