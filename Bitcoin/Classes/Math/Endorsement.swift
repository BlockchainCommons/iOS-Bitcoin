//
//  Endorsement.swift
//  Bitcoin
//
//  Created by Wolf McNally on 11/20/18.
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

/// DER encoded signature with sighash byte for contract endorsement:
public struct Endorsement {
    public let data: Data

    public init(_ data: Data) throws {
        guard (9 ... 72).contains(data.count) else {
            throw BitcoinError.invalidDataSize
        }
        self.data = data
    }
}

// MARK: - Free functions

public func toEndorsement(_ data: Data) throws -> Endorsement {
    return try Endorsement(data)
}
