//
//  TestTxRef.swift
//  BitcoinTests
//
//  Created by Wolf McNally on 11/8/19.
//  Copyright © 2019 Blockchain Commons. All rights reserved.
//

import XCTest
import Foundation
import Bitcoin
import WolfFoundation
import WolfPipe

///
/// Tests from `Bech32 Encoded Tx Position References`
/// https://github.com/bitcoin/bips/blob/master/bip-0136.mediawiki
/// https://github.com/WebOfTrustInfo/btcr-hackathon-2019/issues/5
///

class TestTxRef: XCTestCase {
    func testValid() throws {
        let tests: [(EncodedTxRef, TxRef)] = [
            // Mainnet, no outIndex
            ("tx1:rqqq-qqqq-qmhu-qhp", TxRef(network: .mainnet, blockHeight: 0x0, txIndex: 0x0)),
            ("tx1:rqqq-qqll-l8xh-jkg", TxRef(network: .mainnet, blockHeight: 0x0, txIndex: 0x7FFF)),
            ("tx1:r7ll-llqq-qghq-qr8", TxRef(network: .mainnet, blockHeight: 0xFFFFFF, txIndex: 0x0)),
            ("tx1:r7ll-llll-l5xt-jzw", TxRef(network: .mainnet, blockHeight: 0xFFFFFF, txIndex: 0x7FFF)),

            // Mainnet, outIndex zero
            ("tx1:rqqq-qqqq-qmhu-qhp", TxRef(network: .mainnet, blockHeight: 0x0, txIndex: 0x0, outIndex: 0x0)),
            ("tx1:rqqq-qqll-l8xh-jkg", TxRef(network: .mainnet, blockHeight: 0x0, txIndex: 0x7FFF, outIndex: 0x0)),
            ("tx1:r7ll-llqq-qghq-qr8", TxRef(network: .mainnet, blockHeight: 0xFFFFFF, txIndex: 0x0, outIndex: 0x0)),
            ("tx1:r7ll-llll-l5xt-jzw", TxRef(network: .mainnet, blockHeight: 0xFFFFFF, txIndex: 0x7FFF, outIndex: 0x0)),

            // Mainnet, output non-zero
            ("tx1:yqqq-qqqq-qpqq-5j9q-nz", TxRef(network: .mainnet, blockHeight: 0x0, txIndex: 0x0, outIndex: 0x1)),
            ("tx1:yqqq-qqll-lpqq-wd7a-nw", TxRef(network: .mainnet, blockHeight: 0x0, txIndex: 0x7FFF, outIndex: 0x1)),
            ("tx1:y7ll-llqq-qpqq-lktn-jq", TxRef(network: .mainnet, blockHeight: 0xFFFFFF, txIndex: 0x0, outIndex: 0x1)),
            ("tx1:y7ll-llll-lpqq-9fsw-jv", TxRef(network: .mainnet, blockHeight: 0xFFFFFF, txIndex: 0x7FFF, outIndex: 0x1)),
            ("tx1:yjk0-uqay-zrfq-g2cg-t8", TxRef(network: .mainnet, blockHeight: 0x71F69, txIndex: 0x89D, outIndex: 0x123)),
            ("tx1:yjk0-uqay-zu4x-nk6u-pc", TxRef(network: .mainnet, blockHeight: 0x71F69, txIndex: 0x89D, outIndex: 0x1ABC)),


            // Testnet, no outIndex
            ("txtest1:xqqq-qqqq-qkla-64l", TxRef(network: .testnet, blockHeight: 0x0, txIndex: 0x0)),
            ("txtest1:xqqq-qqll-l2wk-g5k", TxRef(network: .testnet, blockHeight: 0x0, txIndex: 0x7FFF)),
            ("txtest1:x7ll-llqq-q9lp-6pe", TxRef(network: .testnet, blockHeight: 0xFFFFFF, txIndex: 0x0)),
            ("txtest1:x7ll-llll-lew2-gqs", TxRef(network: .testnet, blockHeight: 0xFFFFFF, txIndex: 0x7FFF)),

            // Testnet, outIndex zero
            ("txtest1:xqqq-qqqq-qkla-64l", TxRef(network: .testnet, blockHeight: 0x0, txIndex: 0x0, outIndex: 0x0)),
            ("txtest1:xqqq-qqll-l2wk-g5k", TxRef(network: .testnet, blockHeight: 0x0, txIndex: 0x7FFF, outIndex: 0x0)),
            ("txtest1:x7ll-llqq-q9lp-6pe", TxRef(network: .testnet, blockHeight: 0xFFFFFF, txIndex: 0x0, outIndex: 0x0)),
            ("txtest1:x7ll-llll-lew2-gqs", TxRef(network: .testnet, blockHeight: 0xFFFFFF, txIndex: 0x7FFF, outIndex: 0x0)),

            // Testnet, outIndex non-zero
            ("txtest1:8qqq-qqqq-qpqq-622t-s9", TxRef(network: .testnet, blockHeight: 0x0, txIndex: 0x0, outIndex: 0x1)),
            ("txtest1:8qqq-qqll-lpqq-q43k-sf", TxRef(network: .testnet, blockHeight: 0x0, txIndex: 0x7FFF, outIndex: 0x1)),
            ("txtest1:87ll-llqq-qpqq-3wyc-38", TxRef(network: .testnet, blockHeight: 0xFFFFFF, txIndex: 0x0, outIndex: 0x1)),
            ("txtest1:87ll-llll-lpqq-t3l9-3t", TxRef(network: .testnet, blockHeight: 0xFFFFFF, txIndex: 0x7FFF, outIndex: 0x1)),
            ("txtest1:8jk0-uqay-zrfq-xjhr-gq", TxRef(network: .testnet, blockHeight: 0x71F69, txIndex: 0x89D, outIndex: 0x123)),
            ("txtest1:8jk0-uqay-zu4x-aw4h-zl", TxRef(network: .testnet, blockHeight: 0x71F69, txIndex: 0x89D, outIndex: 0x1ABC))
        ]

        try tests.forEach {
            let (encodedTxRef, txRef) = $0
            let decoded = try encodedTxRef |> toDecoded
            XCTAssertEqual(decoded, txRef)
            let encoded = decoded |> toEncoded
            XCTAssertEqual(encoded, encodedTxRef)
        }
    }

    func testValidNoncanonical() throws {
        let tests: [(EncodedTxRef, TxRef)] = [
            ("tx1:rjk0-uqay-zsrw-hqe", TxRef(network: .mainnet, blockHeight: 0x71F69, txIndex: 0x89D)),
            ("TX1RJK0UQAYZSRWHQE", TxRef(network: .mainnet, blockHeight: 0x71F69, txIndex: 0x89D)),
            ("TX1RJK0--UQaYZSRw----HQE", TxRef(network: .mainnet, blockHeight: 0x71F69, txIndex: 0x89D)),
            ("tx1 rjk0 uqay zsrw hqe", TxRef(network: .mainnet, blockHeight: 0x71F69, txIndex: 0x89D)),
            ("tx1!rjk0\\uqay*zsrw^^hqe", TxRef(network: .mainnet, blockHeight: 0x71F69, txIndex: 0x89D))
        ]

        try tests.forEach {
            let (encodedTxRef, txRef) = $0
            let decoded = try encodedTxRef |> toDecoded
            XCTAssertEqual(decoded, txRef)
        }
    }

    func testInvalid() throws {
        let tests: [EncodedTxRef] = [
            "tx1:t7ll-llll-ldup-3hh",
            "tx1:rlll-llll-lfet-r2y",
            "tx1:rjk0-u5ng-gghq-fkg7",
            "tx1:rjk0-u5qd-s43z",
            "tx1:yqqq-qqqq-qqqq-ksvh-26" // zero out index
        ]

        try tests.forEach { encodedTxRef in
            XCTAssertThrowsError( try encodedTxRef |> toDecoded )
        }
    }
}
