//
//  TestBech32Bis.swift
//  BitcoinDemo
//
//  Created by Wolf McNally on 1/24/20.
//  Copyright © 2020 Blockchain Commons. All rights reserved.
//

import XCTest
import Foundation
import Bitcoin
import WolfPipe
import WolfFoundation

class TestBech32Bis: XCTestCase {
    func test1() throws {
        let string = "tx1:rqqq-qqqq-qygr-lgl"
        let encodedTxRef = string |> tagEncodedTxRef
        let txRef = try encodedTxRef |> toDecoded(version: .bech32bis)
        XCTAssertEqual(txRef.network, .mainnet)
        XCTAssertEqual(txRef.blockHeight, 0)
        XCTAssertEqual(txRef.txIndex, 0)
        XCTAssertEqual(txRef.outIndex, 0)
        XCTAssertEqual(txRef |> toEncoded(version: .bech32bis) |> rawValue, string)
    }

    func test2() throws {
        let string = "txtest1:xjk0-uqay-zz5s-jae"
        let encodedTxRef = string |> tagEncodedTxRef
        let txRef = try encodedTxRef |> toDecoded(version: .bech32bis)
        XCTAssertEqual(txRef.network, .testnet)
        XCTAssertEqual(txRef.blockHeight, 466793)
        XCTAssertEqual(txRef.txIndex, 2205)
        XCTAssertEqual(txRef.outIndex, 0)
        XCTAssertEqual(txRef |> toEncoded(version: .bech32bis) |> rawValue, string)
    }

    func test3() throws {
        let encodedTxRef = "tx1:yqqq-qqqq-qqqq-f0ng-4y" |> tagEncodedTxRef
        // output index encoded as zero not allowed
        XCTAssertThrowsError( try encodedTxRef |> toDecoded(version: .bech32bis) )
    }

    func test4() throws {
        let string = "txtest1:8jk0-uqay-zu4x-z32g-ap"
        let encodedTxRef = string |> tagEncodedTxRef
        let txRef = try encodedTxRef |> toDecoded(version: .bech32bis)
        XCTAssertEqual(txRef.network, .testnet)
        XCTAssertEqual(txRef.blockHeight, 466793)
        XCTAssertEqual(txRef.txIndex, 2205)
        XCTAssertEqual(txRef.outIndex, 0x1ABC)
        XCTAssertEqual(txRef |> toEncoded(version: .bech32bis) |> rawValue, string)
    }
}

//    txref = "tx1-rqqq-qqqq-qygr-lgl"; // used to be "tx1-rqqq-qqqq-qmhu-qhp"
//    loc = txref::decode(txref);
//    EXPECT_EQ(loc.hrp, "tx");
//    EXPECT_EQ(loc.magicCode, txref::MAGIC_BTC_MAIN); // 3
//    EXPECT_EQ(loc.blockHeight, 0);
//    EXPECT_EQ(loc.transactionPosition, 0);
//    EXPECT_EQ(loc.txoIndex, 0);
//
//    txref = "txtest1-xjk0-uqay-zz5s-jae"; // used to be "txtest1-xjk0-uqay-zat0-dz8"
//    loc = txref::decode(txref);
//    EXPECT_EQ(loc.hrp, "txtest");
//    EXPECT_EQ(loc.magicCode, txref::MAGIC_BTC_TEST); // 6
//    EXPECT_EQ(loc.blockHeight, 466793);
//    EXPECT_EQ(loc.transactionPosition, 2205);
//    EXPECT_EQ(loc.txoIndex, 0);
//
//    txref = "tx1:yqqq-qqqq-qqqq-f0ng-4y"; // used to be "tx1:yqqq-qqqq-qqqq-ksvh-26"
//    loc = txref::decode(txref);
//    EXPECT_EQ(loc.hrp, "tx");
//    EXPECT_EQ(loc.magicCode, txref::MAGIC_BTC_MAIN_EXTENDED); // 4
//    EXPECT_EQ(loc.blockHeight, 0);
//    EXPECT_EQ(loc.transactionPosition, 0);
//    EXPECT_EQ(loc.txoIndex, 0);
//
//    txref = "txtest1:8jk0-uqay-zu4x-z32g-ap"; // used to be "txtest1:8jk0-uqay-zu4x-aw4h-zl"
//    loc = txref::decode(txref);
//    EXPECT_EQ(loc.hrp, "txtest");
//    EXPECT_EQ(loc.magicCode, txref::MAGIC_BTC_TEST_EXTENDED); // 7
//    EXPECT_EQ(loc.blockHeight, 466793);
//    EXPECT_EQ(loc.transactionPosition, 2205);
//    EXPECT_EQ(loc.txoIndex, 0x1ABC);
