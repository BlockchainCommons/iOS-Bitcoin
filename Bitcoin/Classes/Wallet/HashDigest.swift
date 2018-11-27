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

public struct HashDigest {
    public let data: Data

    public init(_ data: Data) throws {
        guard data.count == 32 else {
            throw BitcoinError.invalidDataSize
        }
        self.data = data
    }

    public init() {
        self.data = Data(count: 32)
    }

    public static let null = HashDigest()
}

extension HashDigest: CustomStringConvertible {
    public var description: String {
        return data |> base16Encode
    }
}

extension HashDigest: Equatable {
    public static func == (lhs: HashDigest, rhs: HashDigest) -> Bool {
        return lhs.data == rhs.data
    }
}

// MARK: - Free functions

public func toHashDigest(_ data: Data) throws -> HashDigest {
    return try HashDigest(data)
}

public func hashEncode(_ hash: HashDigest) -> String {
    return hash.data |> reversed |> base16Encode
}

public func hashDecode(_ string: String) throws -> HashDigest {
    return try string |> base16Decode |> reversed |> toHashDigest
}
