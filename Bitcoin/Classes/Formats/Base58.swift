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
import WolfFoundation
import WolfPipe

public enum Base58Tag { }
public typealias Base58 = Tagged<Base58Tag, String>
public func tagBase58(_ string: String) -> Base58 { return Base58(rawValue: string) }

public enum Base58CheckTag { }
public typealias Base58Check = Tagged<Base58CheckTag, String>
public func tagBase58Check(_ string: String) -> Base58Check { return Base58Check(rawValue: string) }

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
public func toBase58(_ data: Data) -> Base58 {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Base58 in
        var bytes: UnsafeMutablePointer<Int8>!
        var count: Int = 0
        _encodeBase58(dataBytes, data.count, &bytes, &count)
        return receiveString(bytes: bytes, count: count) |> tagBase58
    }
}

/// Decodes the base58 format string.
///
/// Throws if the string is not valid base58.
public func toData(_ base58: Base58) throws -> Data {
    return try base58®.withCString { (stringBytes) in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        if let error = BitcoinError(rawValue: _decodeBase58(stringBytes, &bytes, &count)) {
            throw error
        }
        return receiveData(bytes: bytes, count: count)
    }
}

/// Encodes the data as a base58check string.
public func toBase58Check(version: UInt8) -> (_ data: Data) -> Base58Check {
    return { data in
        return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Base58Check in
            var bytes: UnsafeMutablePointer<Int8>!
            var count: Int = 0
            _encodeBase58Check(dataBytes, data.count, version, &bytes, &count)
            return receiveString(bytes: bytes, count: count) |> tagBase58Check
        }
    }
}

public func toBase58Check(_ data: Data) -> Base58Check {
    return toBase58Check(version: 0)(data)
}

public func toData(_ base58Check: Base58Check) throws -> (version: UInt8, payload: Data) {
    return try base58Check®.withCString { (stringBytes) in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        var version: UInt8 = 0
        if let error = BitcoinError(rawValue: _decodeBase58Check(stringBytes, &bytes, &count, &version)) {
            throw error
        }
        let data = receiveData(bytes: bytes, count: count)
        return (version, data)
    }
}
