//
//  Base85.swift
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
import WolfCore

public enum Base85Tag { }
public typealias Base85 = Tagged<Base85Tag, String>
public func tagBase85(_ string: String) -> Base85 { return Base85(rawValue: string) }

/// Encodes the data as a base85 string.
public func toBase85(_ data: Data) -> Base85 {
    return data.withUnsafeBytes { dataBytes -> Base85 in
        var bytes: UnsafeMutablePointer<Int8>!
        var count: Int = 0
        _encodeBase85(dataBytes®, data.count, &bytes, &count)
        return receiveString(bytes: bytes, count: count) |> tagBase85
    }
}

/// Decodes the base85 format string.
///
/// Throws if the string is not valid base85.
public func toData(_ base85: Base85) throws -> Data {
    return try base85®.withCString { (stringBytes) in
        var bytes: UnsafeMutablePointer<UInt8>!
        var count: Int = 0
        if let error = BitcoinError(rawValue: _decodeBase85(stringBytes, &bytes, &count)) {
            throw error
        }
        return receiveData(bytes: bytes, count: count)
    }
}
