//
//  ECPrivateKey.swift
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
import WolfCore

public let ecPrivateKeySize: Int = { return _ecPrivateKeySize() }()

public class ECPrivateKey: ECKey {
    public convenience init() {
        try! self.init(seed(count: ecPrivateKeySize))
    }

    public init(_ rawValue: Data) throws {
        guard rawValue.count == ecPrivateKeySize else {
            throw BitcoinError.invalidDataSize
        }
        super.init(rawValue: rawValue)
    }

    public required init(rawValue: Data) {
        fatalError("init(rawValue:) has not been implemented")
    }
}

// MARK: - Free functions

public func toECPrivateKey(_ data: Data) throws -> ECPrivateKey {
    return try ECPrivateKey(data)
}

/// Create a new EC private key from entropy.
public func newECPrivateKey(_ entropy: Data) throws -> ECPrivateKey {
    guard entropy.count >= minimumSeedSize else {
        throw BitcoinError.seedTooSmall
    }
    var privateKeyBytes: UnsafeMutablePointer<UInt8>!
    var privateKeyLength: Int = 0
    try entropy.withUnsafeBytes { seedBytes in
        if let error = BitcoinError(rawValue: _ecNewPrivateKey(seedBytes®, entropy.count, &privateKeyBytes, &privateKeyLength)) {
            throw error
        }
    }
    return try ECPrivateKey(receiveData(bytes: privateKeyBytes, count: privateKeyLength))
}

public func toECPrivateKey(_ hdPrivateKey: HDKey) throws -> ECPrivateKey {
    let ecKey = try hdPrivateKey |> toECKey
    guard let ecPrivateKey = ecKey as? ECPrivateKey else {
        throw BitcoinError.invalidDerivation
    }
    return ecPrivateKey
}
