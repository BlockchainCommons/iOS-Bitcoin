//
//  Base16.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/24/18.
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

/// Encodes the data as a base16 (hex) string.
public func base16Encode(_ data: Data) -> String {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> String in
        var bytes: UnsafeMutablePointer<Int8>!
        var count: Int = 0
        _base16Encode(dataBytes, data.count, &bytes, &count)
        return receiveString(bytes: bytes, count: count)
    }
}

/// Decodes the base16 (hex) format string.
///
/// Throws if the string is not valid base16.
public func base16Decode(_ string: String) throws -> Data {
    return try string.withCString { (stringBytes) in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        if let error = BitcoinError(rawValue: _base16Decode(stringBytes, &bytes, &count)) {
            throw error
        }
        return receiveData(bytes: bytes, count: count)
    }
}

/// Encodes the bitcoin hash as a string.
///
/// The bitcoin hash format is like base16, but with the bytes reversed.
/// Throws if the input data is not exactly 32 bytes long.
public func bitcoinHashEncode(_ data: Data) throws -> String {
    guard data.count == 32 else {
        throw BitcoinError.invalidFormat
    }
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> String in
        var bytes: UnsafeMutablePointer<Int8>!
        var count: Int = 0
        _bitcoinHashEncode(dataBytes, &bytes, &count)
        return receiveString(bytes: bytes, count: count)
    }
}

/// Decodes the base16 (hex) format string.
///
/// The bitcoin hash format is like base16, but with the bytes reversed.
/// Throws if the string is not valid base16.
public func bitcoinHashDecode(_ string: String) throws -> Data {
    return try string.withCString { (stringBytes) in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        if let error = BitcoinError(rawValue: _bitcoinHashDecode(stringBytes, &bytes, &count)) {
            throw error
        }
        return receiveData(bytes: bytes, count: count)
    }
}
