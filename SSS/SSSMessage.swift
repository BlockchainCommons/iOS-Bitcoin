//
//  SSSMessage.swift
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

import WolfFoundation
import WolfPipe
import CBitcoin

public struct SSSMessage: RawRepresentable {
    private typealias `Self` = SSSMessage

    public static let length = _sss_message_length()

    public var rawValue: Data

    public init?(rawValue: Data) {
        guard rawValue.count == Self.length else {
            return nil
        }
        self.rawValue = rawValue
    }
}

extension SSSMessage: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension SSSMessage: Equatable {
    public static func == (lhs: SSSMessage, rhs: SSSMessage) -> Bool {
        return lhs® == rhs®
    }
}

extension SSSMessage: CustomStringConvertible {
    public var description: String {
        return rawValue |> toBase16 |> WolfPipe.rawValue
    }
}
