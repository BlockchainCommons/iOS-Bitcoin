//
//  TestFormats.swift
//  Bitcoin_Tests
//
//  Created by Wolf McNally on 09/15/2018.
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

import XCTest
import Bitcoin
import WolfPipe
import WolfFoundation

class TestFormats: XCTestCase {
    func testBitcoinError() {
        XCTAssertEqual(BitcoinError(rawValue: 1)!.description, "Error code")
    }

    func testLibBitcoinResult() {
        XCTAssertEqual(LibBitcoinResult(code: 1).description, "libbitcoin error 1")
    }

    func testBase10() {
        XCTAssert(btcDecimalPlaces == 8)
        XCTAssert(mbtcDecimalPlaces == 5)
        XCTAssert(ubtcDecimalPlaces == 2)

        let satoshis: UInt64 = 1012345678
        let satoshisString: Base10 = "1012345678"
        let btcString: Base10 = "10.12345678"
        XCTAssert(satoshis |> toBase10 == satoshisString)
        XCTAssert(satoshis |> toBase10(decimalPlaces: btcDecimalPlaces) == btcString)
        XCTAssert(try! satoshisString |> base10Decode == satoshis)
        XCTAssert(try! btcString |> base10Decode(decimalPlaces: btcDecimalPlaces) == satoshis)
        XCTAssertThrowsError(try "Foobar" |> base10Decode == satoshis) // Invalid format
        XCTAssertThrowsError(try btcString |> base10Decode(decimalPlaces: 1) == satoshis) // incorrect decimal place
    }

    func testBase16() {
        let data = Data(bytes: [0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff])
        let hexString: Base16 = "00112233445566778899aabbccddeeff"

        XCTAssert(data |> toBase16 == hexString)
        XCTAssert(try! hexString |> toData == data)
        XCTAssertThrowsError(try "0123456789abcdefg" |> tagBase16 |> toData) // Invalid characters
        XCTAssert(try! hexString |> toData |> toBase16 == hexString)
    }

    func testBase16Hash() {
        let hashData = Data(bytes: [0x18, 0x5f, 0x8d, 0xb3, 0x22, 0x71, 0xfe, 0x25, 0xf5, 0x61, 0xa6, 0xfc, 0x93, 0x8b, 0x2e, 0x26, 0x43, 0x06, 0xec, 0x30, 0x4e, 0xda, 0x51, 0x80, 0x07, 0xd1, 0x76, 0x48, 0x26, 0x38, 0x19, 0x69])
        let hash: BitcoinHash = "691938264876d1078051da4e30ec0643262e8b93fca661f525fe7122b38d5f18"
        XCTAssert(try! hashData |> toBitcoinHash == hash)
        XCTAssert(try! hash |> toData == hashData)
        XCTAssertThrowsError(try Data(bytes: [0x01, 0x02]) |> toBitcoinHash == hash) // Wrong length
        XCTAssertThrowsError(try "" |> tagBitcoinHash |> toData == hashData) // Empty string
        XCTAssertThrowsError(try "010203" |> tagBitcoinHash |> toData == hashData) // Wrong length
        XCTAssertThrowsError(try (hash.rawValue + "x") |> BitcoinHash.init(rawValue:) |> toData == hashData) // Invalid character
    }

    func testBase32() {
        func test(prefix: String, payload: String, expected: String) throws -> Bool {
            let payloadData = payload |> dataLiteral
            let encoded = payloadData |> toBase32(prefix: prefix)
            guard encoded == expected |> tagBase32 else { return false }
            let (decodedPrefix, decodedPayload) = try encoded |> toData
            guard decodedPrefix == prefix, decodedPayload == payloadData else { return false }
            return true
        }
        XCTAssert(try! test(prefix: "a", payload: "", expected: "a12uel5l"))
        XCTAssert(try! test(prefix: "abcdef", payload: "000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f", expected: "abcdef1qpzry9x8gf2tvdw0s3jn54khce6mua7lmqqqxw"))
        XCTAssert(try! test(prefix: "split", payload: "18171918161c01100b1d0819171d130d10171d16191c01100b03191d1b1903031d130b190303190d181d01190303190d", expected: "split1checkupstagehandshakeupstreamerranterredcaperred2y9e3w"))
    }

    func testBase58() {
        XCTAssert(Character("c").isBase58)
        XCTAssertFalse(Character("?").isBase58)

        let testData = "007680adec8eabcabac676be9e83854ade0bd22cdb0bb960de" |> dataLiteral
        let base58Encoded: Base58 = "1BoatSLRHtKNngkdXEeobR76b53LETtpyT"
        XCTAssert(base58Encoded.rawValue.isBase58)
        XCTAssertFalse("F00bar".isBase58) // Invalid format
        XCTAssert(testData |> toBase58 == base58Encoded)
        XCTAssert(try! base58Encoded |> toData == testData)
        XCTAssert(try! "" |> tagBase58 |> toData |> fromUTF8 == "") // Empty string
        XCTAssertThrowsError(try "1BoatSLRHtKNngkdXEeobR76b53LETtpy!" |> tagBase58 |> toData == testData) // Invalid character
    }

    func testBase58Check() {
        let testData = "f54a5851e9372b87810a8e60cdd2e7cfd80b6e31" |> dataLiteral
        let base58CheckEncoded = "1PMycacnJaSqwwJqjawXBErnLsZ7RkXUAs" |> tagBase58Check
        XCTAssert(testData |> toBase58Check == base58CheckEncoded)
        XCTAssert(try! base58CheckEncoded |> toData == (0, testData))
        XCTAssertThrowsError(try "" |> tagBase58Check |> toData == (0, testData)) // Empty string
    }

    func testBase64() {
        let testString = "Foobar"
        let base64Encoded: Bitcoin.Base64 = "Rm9vYmFy"
        XCTAssert(testString |> toUTF8 |> Bitcoin.toBase64 == base64Encoded)
        XCTAssert(try! base64Encoded |> toData |> fromUTF8 == testString)
        XCTAssert(try! "" |> Bitcoin.tagBase64 |> toData |> fromUTF8 == "") // Empty string
        XCTAssertThrowsError(try "Rm9vYmFy0" |> Bitcoin.tagBase64 |> toData |> fromUTF8 == testString) // Invalid character
    }

    func testBase85() {
        let testString = "Hello World!"
        let base85Encoded: Base85 = "SGVsbG8gV29ybGQh"
        XCTAssert(testString |> toUTF8 |> Bitcoin.toBase85 == base85Encoded)
        XCTAssert(try! base85Encoded |> toData |> fromUTF8 == testString)
        XCTAssert(try! "" |> tagBase85 |> toData |> fromUTF8 == "") // Empty string
        XCTAssertThrowsError(try "SGVsbG8gV29ybGQ'" |> tagBase85 |> toData |> fromUTF8 == testString) // Invalid character
    }
}
