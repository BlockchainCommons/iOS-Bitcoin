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

/// Encodes the data as a base32 string.
public func base32Encode(prefix: String) -> (_ payload: Data) -> String {
    return { payload in
        return payload.withUnsafeBytes { (dataBytes: UnsafePointer<UInt8>) -> String in
            prefix.withCString { prefixBytes in
                var bytes: UnsafeMutablePointer<Int8>!
                var count: Int = 0
                _base32Encode(prefixBytes, dataBytes, payload.count, &bytes, &count)
                return receiveString(bytes: bytes, count: count)
            }
        }
    }
}

/// Decodes the base32 format string.
///
/// Throws if the string is not valid base32.
public func base32Decode(_ string: String) throws -> (prefix: String, payload: Data) {
    return try string.withCString { (stringBytes) in
        var prefixBytes: UnsafeMutablePointer<Int8>!
        var prefixCount: Int = 0
        var payloadBytes: UnsafeMutablePointer<UInt8>!
        var payloadCount: Int = 0
        if let error = BitcoinError(rawValue: _base32Decode(stringBytes, &prefixBytes, &prefixCount, &payloadBytes, &payloadCount)) {
            throw error
        }
        let prefix = receiveString(bytes: prefixBytes, count: prefixCount)
        let payload = receiveData(bytes: payloadBytes, count: payloadCount)
        return (prefix, payload)
    }
}
