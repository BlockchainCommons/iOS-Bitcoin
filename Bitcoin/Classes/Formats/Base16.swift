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
import WolfFoundation
import WolfPipe

public enum Base16Tag { }
public typealias Base16 = Tagged<Base16Tag, String>
public func tagBase16(_ string: String) -> Base16 { return Base16(rawValue: string) }

/// Encodes the data as a base16 (hex) string.
public func toBase16(_ data: Data) -> Base16 {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Base16 in
        var bytes: UnsafeMutablePointer<Int8>!
        var count: Int = 0
        _encodeBase16(dataBytes, data.count, &bytes, &count)
        return receiveString(bytes: bytes, count: count) |> tagBase16
    }
}

/// Decodes the base16 (hex) format string.
///
/// Throws if the string is not valid base16.
public func toData(_ base16: Base16) throws -> Data {
    return try base16®.withCString { (stringBytes) in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        if let error = BitcoinError(rawValue: _decodeBase16(stringBytes, &bytes, &count)) {
            throw error
        }
        return receiveData(bytes: bytes, count: count)
    }
}
