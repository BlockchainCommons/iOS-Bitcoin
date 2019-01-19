//
//  Base64.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/25/18.
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

public enum Base64Tag { }
public typealias Base64 = Tagged<Base64Tag, String>
public func tagBase64(_ string: String) -> Base64 { return Base64(rawValue: string) }

/// Encodes the data as a base64 string.
public func toBase64(_ data: Data) -> Base64 {
    return data.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> Base64 in
        var bytes: UnsafeMutablePointer<Int8>!
        var count: Int = 0
        _encodeBase64(dataBytes, data.count, &bytes, &count)
        return receiveString(bytes: bytes, count: count) |> tagBase64
    }
}

/// Decodes the base64 format string.
///
/// Throws if the string is not valid base64.
public func toData(_ base64: Base64) throws -> Data {
    return try base64®.withCString { (stringBytes) in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        if let error = BitcoinError(rawValue: _decodeBase64(stringBytes, &bytes, &count)) {
            throw error
        }
        return receiveData(bytes: bytes, count: count)
    }
}
