//
//  RuleFork.swift
//  Pods
//
//  Created by Wolf McNally on 11/12/18.
//
//  Copyright © 2019 Blockchain Commons.
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

public struct RuleFork: OptionSet {
    public let rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    public static let noRules = RuleFork(rawValue: 0)

    /// Allow minimum difficulty blocks (hard fork, testnet).
    public static let difficult = RuleFork(rawValue: 1 << 0)

    /// Perform difficulty retargeting (hard fork, regtest).
    public static let retarget = RuleFork(rawValue: 1 << 1)

    /// Pay-to-script-hash enabled (soft fork, feature).
    public static let bip16Rule = RuleFork(rawValue: 1 << 2)

    /// No duplicated unspent transaction ids (soft fork, security).
    public static let bip30Rule = RuleFork(rawValue: 1 << 3)

    /// Coinbase must include height (soft fork, security).
    public static let bip34Rule = RuleFork(rawValue: 1 << 4)

    /// Strict DER signatures required (soft fork, security).
    public static let bip66Rule = RuleFork(rawValue: 1 << 5)

    /// Operation nop2 becomes check locktime verify (soft fork, feature).
    public static let bip65Rule = RuleFork(rawValue: 1 << 6)

    /// Hard code bip34-based activation heights (hard fork, optimization).
    public static let bip90Rule = RuleFork(rawValue: 1 << 7)

    /// Enforce relative locktime (soft fork, feature).
    public static let bip68Rule = RuleFork(rawValue: 1 << 8)

    /// Operation nop3 becomes check sequence verify (soft fork, feature).
    public static let bip112Rule = RuleFork(rawValue: 1 << 9)

    /// Use median time past for locktime (soft fork, feature).
    public static let bip113Rule = RuleFork(rawValue: 1 << 10)

    /// Segregated witness consensus layer (soft fork, feature).
    public static let bip141Rule = RuleFork(rawValue: 1 << 11)

    /// Segregated witness v0 verification (soft fork, feature).
    public static let bip143Rule = RuleFork(rawValue: 1 << 12)

    /// Prevent dummy value malleability (soft fork, feature).
    public static let bip147Rule = RuleFork(rawValue: 1 << 13)

    /// Fix Satoshi's time warp bug (hard fork, security).
    public static let timeWarpPatch = RuleFork(rawValue: 1 << 14)

    /// Fix target overflow for very low difficulty (hard fork, security).
    public static let retargetOverflowPatch = RuleFork(rawValue: 1 << 15)

    /// Use scrypt hashing for proof of work (hard fork, feature).
    public static let scryptProofOfWork = RuleFork(rawValue: 1 << 16)

    /// Sentinel bit to indicate tx has not been validated.
    public static let unverified = RuleFork(rawValue: 1 << 31)

    /// Rules that use bip34-based activation.
    public static let bip34Activations: RuleFork = [.bip34Rule, .bip65Rule, .bip66Rule]

    /// Rules that use BIP9 bit zero first time activation.
    public static let bip9Bit0Group: RuleFork = [.bip68Rule, .bip112Rule, .bip113Rule]

    /// Rules that use BIP9 bit one first time activation.
    public static let bip9Bit1Group: RuleFork = [.bip141Rule, .bip143Rule, .bip147Rule]

    /// Simple mask to set all bits.
    public static let allRules = RuleFork(rawValue: 0xffffffff)
}
