//
//  SSSShare.swift
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

import WolfCore
import CBitcoin

public struct SSSShare {
    private typealias `Self` = SSSShare

    public static let length = _sss_share_length()

    public let data: Data

    public init(data: Data) throws {
        guard data.count == Self.length else {
            throw BitcoinError.invalidDataSize
        }
        self.data = data
    }

    public init(base64: Base64) throws {
        data = try base64 |> toData
        guard data.count == Self.length else {
            throw BitcoinError.invalidDataSize
        }
    }

    public var base64: Base64 {
        return data |> toBase64
    }
}

extension SSSShare: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(data)
    }
}

extension SSSShare: Equatable {
    public static func == (lhs: SSSShare, rhs: SSSShare) -> Bool {
        return lhs.data == rhs.data
    }
}

extension SSSShare: CustomStringConvertible {
    public var description: String {
        return data |> toBase16 |> rawValue
    }
}
