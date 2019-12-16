//
//  Base32.swift
//  Bitcoin
//
//  Created by Wolf McNally on 10/27/18.
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

public enum Base32Tag { }
public typealias Base32 = Tagged<Base32Tag, String>
public func tagBase32(_ string: String) -> Base32 { return Base32(rawValue: string) }

/// Convert the data to Base32 with the provided prefix.
public func toBase32(prefix: String, payload: Data) -> Base32 {
    return payload.withUnsafeBytes { dataBytes -> Base32 in
        prefix.withCString { prefixBytes in
            var bytes: UnsafeMutablePointer<Int8>!
            var count: Int = 0
            _encodeBase32(prefixBytes, dataBytes®, payload.count, &bytes, &count)
            return receiveString(bytes: bytes, count: count) |> tagBase32
        }
    }
}

/// Convert the data to Base32 with the provided prefix.
public func toBase32(prefix: String) -> (_ payload: Data) -> Base32 {
    return { payload in
        toBase32(prefix: prefix, payload: payload)
    }
}

/// Decodes the base32 format string.
///
/// Throws if the string is not valid base32.
public func toData(_ base32: Base32) throws -> (prefix: String, payload: Data) {
    return try base32®.withCString { (stringBytes) in
        var prefixBytes: UnsafeMutablePointer<Int8>!
        var prefixCount: Int = 0
        var payloadBytes: UnsafeMutablePointer<UInt8>!
        var payloadCount: Int = 0
        if let error = BitcoinError(rawValue: _decodeBase32(stringBytes, &prefixBytes, &prefixCount, &payloadBytes, &payloadCount)) {
            throw error
        }
        let prefix = receiveString(bytes: prefixBytes, count: prefixCount)
        let payload = receiveData(bytes: payloadBytes, count: payloadCount)
        return (prefix, payload)
    }
}
