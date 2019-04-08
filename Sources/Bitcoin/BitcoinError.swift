//
//  BitcoinError.swift
//  Bitcoin
//
//  Created by Wolf McNally on 9/15/18.
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

import WolfCore

public struct LibBitcoinResult: CodedError, CustomStringConvertible {
    public let code: Int

    public init(code: UInt32) {
        self.code = Int(code)
    }

    public var isSuccess: Bool {
        return code == 0
    }

    public var description: String {
        return "libbitcoin error \(code)"
    }
}

public enum BitcoinError: Int, Error, CustomStringConvertible, CaseIterable {
    private typealias `Self` = BitcoinError

    case errorCode = 1
    case invalidFormat = 2
    case invalidDataSize = 3
    case seedTooSmall = 4
    case invalidSeedSize = 5
    case invalidSeed = 6
    case unsupportedLanguage = 7
    case invalidVersion = 8
    case privateKeyRequired = 9
    case invalidKey = 10
    case invalidAddress = 11
    case invalidChecksum = 12
    case invalidScript = 13
    case invalidTransaction = 14
    case invalidData = 15
    case invalidOpcode = 16
    case invalidSignature = 17
    case signingFailed = 18
    case invalidDerivation = 19
    case noRandomNumberSource = 20

    private static let descriptions: [BitcoinError: String] = [
        .errorCode: "Error code",
        .invalidFormat: "Invalid format",
        .invalidDataSize: "Invalid data size",
        .seedTooSmall: "Seed size too small",
        .invalidSeedSize: "Invalid seed size",
        .invalidSeed: "Invalid seed",
        .unsupportedLanguage: "Unsupported language",
        .invalidVersion: "Invalid version",
        .privateKeyRequired: "Private key required",
        .invalidKey: "Invalid key",
        .invalidAddress: "Invalid address",
        .invalidChecksum: "Invalid checksum",
        .invalidScript: "Invalid script",
        .invalidTransaction: "Invalid transaction",
        .invalidData: "Invalid data",
        .invalidOpcode: "Invalid opcode",
        .invalidSignature: "Invalid signature",
        .signingFailed: "Signing failed",
        .invalidDerivation: "Invalid derivation",
        .noRandomNumberSource: "No random number source available"
    ]

    public var description: String {
        assert(BitcoinError.allCases.count == Self.descriptions.count)
        return Self.descriptions[self]!
    }
}
