//
//  Mnemonic.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/29/18.
//

import CBitcoin

/// A valid mnemonic word count is evenly divisible by this number.
public let mnemonicWordMultiple: Int = { return _mnemonicWordMultiple() }()

/// A valid seed byte count is evenly divisible by this number.
public let mnemonicSeedMultiple: Int = { return _mnemonicSeedMultiple() }()

public enum Language: String {
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

public func mnemonicNew(language: Language) -> (_ seed: Data) throws -> String {
    return { seed in
        guard seed.count % mnemonicSeedMultiple == 0 else {
            throw BitcoinError("Seed size must be muliple of \(mnemonicSeedMultiple) bytes.")
        }
        guard let dictionary = _dictionaryForLanguage(language.rawValue.cString(using: .utf8)) else {
            throw BitcoinError("Unsupported language.")
        }
        var mnemonic: UnsafeMutablePointer<Int8>!
        var mnemonicLength: Int = 0
        let success = seed.withUnsafeBytes { (seedBytes: UnsafePointer<UInt8>) in
            _mnemonicNew(seedBytes, seed.count, dictionary, &mnemonic, &mnemonicLength)
        }
        guard success else {
            throw BitcoinError("Invalid seed")
        }
        return receiveString(bytes: mnemonic, count: mnemonicLength)
    }
}

public func mnemonicNew(_ seed: Data) throws -> String {
    return try mnemonicNew(language: .en)(seed)
}
