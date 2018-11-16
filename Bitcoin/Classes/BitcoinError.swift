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

import Foundation

public struct LibBitcoinResult: Error, CustomStringConvertible {
    public let code: UInt32

    public init(code: UInt32) {
        self.code = code
    }

    public var isSuccess: Bool {
        return code == 0
    }

    public var description: String {
        return "libbitcoin error \(code)"
    }
}

public enum BitcoinError: Int, Error, CustomStringConvertible {
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

    public var description: String {
        switch self {
        case .errorCode:
            return "Error code"
        case .invalidFormat:
            return "Invalid format"
        case .invalidDataSize:
            return "Invalid data size"
        case .seedTooSmall:
            return "Seed size too small"
        case .invalidSeedSize:
            return "Invalid seed size"
        case .invalidSeed:
            return "Invalid seed"
        case .unsupportedLanguage:
            return "Unsupported language"
        case .invalidVersion:
            return "Invalid version"
        case .privateKeyRequired:
            return "Private key required"
        case .invalidKey:
            return "Invalid key"
        case .invalidAddress:
            return "Invalid address"
        case .invalidChecksum:
            return "Invalid checksum"
        case .invalidScript:
            return "Invalid script"
        case .invalidTransaction:
            return "Invalid transaction"
        case .invalidData:
            return "Invalid data"
        case .invalidOpcode:
            return "Invalid opcode"
        }
    }
}
