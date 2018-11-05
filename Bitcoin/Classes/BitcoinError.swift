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

public enum BitcoinError: Int, Error, CustomStringConvertible {
    case invalidFormat = 1
    case invalidDataSize = 2
    case seedTooSmall = 3
    case invalidSeedSize = 4
    case invalidSeed = 5
    case unsupportedLanguage = 6
    case invalidVersion = 7
    case privateKeyRequired = 8
    case invalidKey = 9
    case invalidAddress = 10

    public var description: String {
        switch self {
        case .seedTooSmall:
            return "Seed size too small"
        case .invalidSeedSize:
            return "Invalid seed size"
        case .invalidSeed:
            return "Invalid seed"
        case .unsupportedLanguage:
            return "Unsupported language"
        case .invalidFormat:
            return "Invalid format"
        case .invalidDataSize:
            return "Invalid data size"
        case .invalidVersion:
            return "Invalid version"
        case .privateKeyRequired:
            return "Private key required"
        case .invalidKey:
            return "Invalid key"
        case .invalidAddress:
            return "Invalid address"
        }
    }
}
