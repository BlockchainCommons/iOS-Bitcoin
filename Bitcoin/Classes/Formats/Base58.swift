//
//  Base58.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/23/18.
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

extension Character {
    /// Returns true if the character is a valid base58 character, false otherwise.
    public var isBase58: Bool {
        guard let a = self.ascii else { return false }
        return _isBase58Char(a)
    }
}

extension String {
    /// Returns true if the string is a valid base58 character, false otherwise.
    public var isBase58: Bool {
        return self.withCString {
            _isBase58String($0)
        }
    }
}

/// Encodes the data as a base58 string.
public func base58Encode(_ data: Data) -> String {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> String in
        var bytes: UnsafeMutablePointer<Int8>!
        var count: Int = 0
        _base58Encode(dataBytes, data.count, &bytes, &count)
        return receiveString(bytes: bytes, count: count)
    }
}

/// Decodes the base58 format string.
///
/// Throws if the string is not valid base58.
public func base58Decode(_ string: String) throws -> Data {
    return try string.withCString { (stringBytes) in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        if let error = BitcoinError(rawValue: _base58Decode(stringBytes, &bytes, &count)) {
            throw error
        }
        return receiveData(bytes: bytes, count: count)
    }
}

/// Encodes the data as a base58check string.
public func base58CheckEncode(version: UInt8) -> (_ data: Data) -> String {
    return { data in
        return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> String in
            var bytes: UnsafeMutablePointer<Int8>!
            var count: Int = 0
            _base58CheckEncode(dataBytes, data.count, version, &bytes, &count)
            return receiveString(bytes: bytes, count: count)
        }
    }
}

public func base58CheckEncode(_ data: Data) -> String {
    return base58CheckEncode(version: 0)(data)
}

public func base58CheckDecode(_ string: String) throws -> (version: UInt8, payload: Data) {
    return try string.withCString { (stringBytes) in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        var version: UInt8 = 0
        if let error = BitcoinError(rawValue: _base58CheckDecode(stringBytes, &bytes, &count, &version)) {
            throw error
        }
        let data = receiveData(bytes: bytes, count: count)
        return (version, data)
    }
}
