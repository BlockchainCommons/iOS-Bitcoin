//
//  ECKey.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/29/18.
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

import Foundation
import WolfPipe
import WolfFoundation

public class ECKey: RawRepresentable, Codable {
    public let rawValue: Data

    public required init(rawValue: Data) {
        self.rawValue = rawValue
    }

    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        rawValue = try container.decode(Data.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension ECKey: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension ECKey: Equatable {
    public static func == (lhs: ECKey, rhs: ECKey) -> Bool {
        return lhs® == rhs®
    }
}

extension ECKey: CustomStringConvertible {
    public var description: String {
        return rawValue |> toBase16 |> WolfPipe.rawValue
    }
}
