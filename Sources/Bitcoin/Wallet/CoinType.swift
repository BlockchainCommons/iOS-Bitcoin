//
//  CoinType.swift
//  Bitcoin
//
//  Created by Wolf McNally on 12/28/18.
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

/// This is an extensible enumerated type. This means that additional members of `CoinType`
/// can be added at compile-time by clients of this module by simply extending `CoinType`
/// with additional `public` `static` members as seen below.
///
/// See also:
///   - Multi-Account Hierarchy for Deterministic Wallets
///   - https://github.com/bitcoin/bips/blob/master/bip-0044.mediawiki
public struct CoinType: RawRepresentable, Hashable, Comparable, CustomStringConvertible {
    public let rawValue: Int

    public init(_ rawValue: Int) {
        self.rawValue = rawValue
    }

    // RawRepresentable
    public init?(rawValue: Int) { self.init(rawValue) }

    // Hashable
    public var hashValue: Int { return rawValue.hashValue }

    // CustomStringConvertible
    public var description: String {
        return String(describing: rawValue)
    }

    public static func < (left: CoinType, right: CoinType) -> Bool {
        return left® < right®
    }

    public static func index(for coinType: CoinType, network: Network) -> Int {
        switch network {
        case .mainnet:
            return coinType®
        case .testnet:
            return CoinType.testnet®
        }
    }
}

/// Please see:
/// SLIP-0044 : Registered coin types for BIP-0044
/// https://github.com/satoshilabs/slips/blob/master/slip-0044.md
extension CoinType {
    public static let btc = CoinType(0)
    public static let testnet = CoinType(1) // all coin types
    public static let ltc = CoinType(2)
    public static let eth = CoinType(60)
    public static let etc = CoinType(61)
    public static let bch = CoinType(145)
}
