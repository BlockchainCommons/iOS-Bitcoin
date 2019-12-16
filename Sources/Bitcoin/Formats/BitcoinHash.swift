//
//  BitcoinHash.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/29/18.
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
import WolfFoundation

public enum BitcoinHashTag { }
public typealias BitcoinHash = Tagged<BitcoinHashTag, String>
public func tagBitcoinHash(_ string: String) -> BitcoinHash { return BitcoinHash(rawValue: string) }

/// Encodes the bitcoin hash as a string.
///
/// The bitcoin hash format is like base16, but with the bytes reversed.
/// Throws if the input data is not exactly 32 bytes long.
public func toBitcoinHash(_ data: Data) throws -> BitcoinHash {
    guard data.count == 32 else {
        throw BitcoinError.invalidFormat
    }
    return data.withUnsafeBytes { dataBytes -> BitcoinHash in
        var bytes: UnsafeMutablePointer<Int8>!
        var count: Int = 0
        _encodeBitcoinHash(dataBytes®, &bytes, &count)
        return BitcoinHash(rawValue: receiveString(bytes: bytes, count: count))
    }
}

/// Decodes the base16 (hex) format string.
///
/// The bitcoin hash format is like base16, but with the bytes reversed.
/// Throws if the string is not valid base16.
public func toData(_ hash: BitcoinHash) throws -> Data {
    return try hash®.withCString { stringBytes in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        if let error = BitcoinError(rawValue: _decodeBitcoinHash(stringBytes, &bytes, &count)) {
            throw error
        }
        return receiveData(bytes: bytes, count: count)
    }
}
