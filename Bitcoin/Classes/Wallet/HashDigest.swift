//
//  HashDigest.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/8/18.
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

import WolfPipe
import WolfFoundation

public enum HashDigestTag { }
public typealias HashDigest = Tagged<HashDigestTag, Data>

public let nullHashDigest = try! Data(repeatElement(0, count: 32)) |> tagHashDigest

//// MARK: - Free functions

public func tagHashDigest(_ data: Data) throws -> HashDigest {
    guard data.count == 32 else {
        throw BitcoinError.invalidDataSize
    }
    return HashDigest(rawValue: data)
}

public func hashEncode(_ hash: HashDigest) -> String {
    return hash.rawValue |> reversed |> toBase16 |> rawValue
}

public func hashDecode(_ string: String) throws -> HashDigest {
    return try string |> dataLiteral |> reversed |> tagHashDigest
}
