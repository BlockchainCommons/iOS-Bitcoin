//
//  Mnemonic.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/29/18.
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
import WolfPipe

/// A valid mnemonic word count is evenly divisible by this number.
public let mnemonicWordMultiple: Int = { return _mnemonicWordMultiple() }()

/// A valid seed byte count is evenly divisible by this number.
public let mnemonicSeedMultiple: Int = { return _mnemonicSeedMultiple() }()

public enum Language: String, CaseIterable {
    case en
    case es
    case ja
    case it
    case fr
    case cs
    case ru
    case uk
    case zh_Hans
    case zh_Hant
}

public func newMnemonic(language: Language) -> (_ seed: Data) throws -> String {
    return { seed in
        guard seed.count % mnemonicSeedMultiple == 0 else {
            throw BitcoinError.invalidSeedSize
        }
        guard let dictionary = _dictionaryForLanguage(language.rawValue.cString(using: .utf8)) else {
            throw BitcoinError.unsupportedLanguage
        }
        var mnemonic: UnsafeMutablePointer<Int8>!
        var mnemonicLength: Int = 0
        try seed.withUnsafeBytes { (seedBytes: UnsafePointer<UInt8>) in
            if let error = BitcoinError(rawValue: _mnemonicNew(seedBytes, seed.count, dictionary, &mnemonic, &mnemonicLength)) {
                throw error
            }
        }
        return receiveString(bytes: mnemonic, count: mnemonicLength)
    }
}

public func newMnemonic(_ seed: Data) throws -> String {
    return try newMnemonic(language: .en)(seed)
}

public func mnemonicToSeed(_ language: Language, passphrase: String? = nil) -> (_ mnemonic: String) throws -> Data {
    return { mnemonic in
        let normalizedMnemonic = mnemonic.precomposedStringWithCanonicalMapping
        let normalizedPassphrase = (passphrase ?? "").precomposedStringWithCanonicalMapping
        guard let dictionary = _dictionaryForLanguage(language.rawValue.cString(using: .utf8)) else {
            throw BitcoinError.unsupportedLanguage
        }
        var seed: UnsafeMutablePointer<UInt8>!
        var seedLength: Int = 0
        try normalizedMnemonic.withCString { mnemonicCStr in
            try normalizedPassphrase.withCString { passphraseCStr in
                if let error = BitcoinError(rawValue: _mnemonicToSeed(mnemonicCStr, dictionary, passphraseCStr, &seed, &seedLength)) {
                    throw error
                }
            }
        }
        return receiveData(bytes: seed, count: seedLength)
    }
}

public func mnemonicToSeedWithPassphrase(_ passphrase: String?) -> (_ mnemonic: String) throws -> Data {
    return { mnemonic in
        var seed: Data!
        _ = Language.allCases.first { language in
            do {
                seed = try mnemonic |> mnemonicToSeed(language, passphrase: passphrase)
                return true
            } catch {
                return false
            }
        }
        guard seed != nil else {
            throw BitcoinError.invalidFormat
        }
        return seed
    }
}

public func mnemonicToSeed(_ mnemonic: String) throws -> Data {
    return try mnemonic |> mnemonicToSeedWithPassphrase(nil)
}
