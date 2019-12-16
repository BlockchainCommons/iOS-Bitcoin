//
//  TestEllipticCurve.swift
//  Bitcoin_Tests
//
//  Created by Wolf McNally on 11/28/18.
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

class TestEllipticCurve: XCTestCase {
    // Scenario 1
    let SECRET1 = try! "8010b1bb119ad37d4b65a1022a314897b1b3614b345974332cb1b9582cf03536" |> dataLiteral |> toECPrivateKey
    let COMPRESSED1 = try! "0309ba8621aefd3b6ba4ca6d11a4746e8df8d35d9b51b383338f627ba7fc732731" |> dataLiteral |> toECPublicKey
    let UNCOMPRESSED1 = try! "0409ba8621aefd3b6ba4ca6d11a4746e8df8d35d9b51b383338f627ba7fc7327318c3a6ec6acd33c36328b8fb4349b31671bcd3a192316ea4f6236ee1ae4a7d8c9" |> dataLiteral |> toECPublicKey

    // Scenario 2
    let COMPRESSED2 = try! "03bc88a1bd6ebac38e9a9ed58eda735352ad10650e235499b7318315cc26c9b55b" |> dataLiteral |> toECPublicKey
    let SIGHASH2 = "ed8f9b40c2d349c8a7e58cebe79faa25c21b6bb85b874901f72a1b3f1ad0a67f" |> dataLiteral
    let SIGNATURE2 = "3045022100bc494fbd09a8e77d8266e2abdea9aef08b9e71b451c7d8de9f63cda33a62437802206b93edd6af7c659db42c579eb34a3a4cb60c28b5a6bc86fd5266d42f6b8bb67d" |> dataLiteral

    // Scenario 3
    let SECRET3 = try! "ce8f4b713ffdd2658900845251890f30371856be201cd1f5b3d970f793634333" |> dataLiteral |> reversed |> toECPrivateKey
    let SIGHASH3 = try! "f89572635651b2e4f89778350616989183c98d1a721c911324bf9f17a0cf5bf0" |> dataLiteral |> reversed |> tagHashDigest
    let EC_SIGNATURE3 = try! "4832febef8b31c7c922a15cb4063a43ab69b099bba765e24facef50dfbb4d057928ed5c6b6886562c2fe6972fd7c7f462e557129067542cce6b37d72e5ea5037" |> dataLiteral |> tagECSignature
    let DER_SIGNATURE3 = try! "3044022057d0b4fb0df5cefa245e76ba9b099bb63aa46340cb152a927c1cb3f8befe324802203750eae5727db3e6cc4275062971552e467f7cfd7269fec2626588b6c6d58e92" |> dataLiteral |> tagDERSignature

    // EC_SUM
    let GENERATOR_POINT_MULT_4 = "02e493dbf1c10d80f3581e4904930b1404cc6c13900ee0758474fa94abe8c4cd13" |> dataLiteral

    func test_secret_to_public__positive() {
        XCTAssertEqual(try! SECRET1 |> toECPublicKey, COMPRESSED1)
    }

    func test_decompress__positive() {
        let uncompressed = try! COMPRESSED1 |> decompress
        XCTAssertEqual(uncompressed, UNCOMPRESSED1)
        let compressed = try! uncompressed |> compress
        XCTAssertEqual(compressed, COMPRESSED1)

        // Redundant compression/decompression
        XCTAssertEqual(try! COMPRESSED1 |> compress, compressed)
        XCTAssertEqual(try! UNCOMPRESSED1 |> decompress, uncompressed)
    }

    func test_sign__positive() {
        XCTAssertEqual(SIGHASH3 |> sign(with: SECRET3), EC_SIGNATURE3)
    }

    func test_encode_signature__positive() {
        XCTAssertEqual(try! EC_SIGNATURE3 |> toDERSignature, DER_SIGNATURE3)
    }

    func testSignMessage() {
        let message = "The quick brown 🦊 jumps over the lazy 🐶." |> toUTF8
        let privateKey = ECPrivateKey()
        let signature = message |> signMessage(with: privateKey)
        let publicKey = try! privateKey |> toECPublicKey
        XCTAssertTrue(message |> verifySignature(publicKey: publicKey, signature: signature))
    }

    func testInvalidKeyLengths() {
        let data = try! "01020304" |> tagHex |> toData
        XCTAssertThrowsError(try data |> toECPrivateKey)
        XCTAssertThrowsError(try data |> toECPublicKey)
    }
}

//    BOOST_AUTO_TEST_CASE(elliptic_curve__encode_signature__positive__test)
//    {
//        der_signature out;
//        const ec_signature signature = base16_literal(EC_SIGNATURE3);
//        BOOST_REQUIRE(encode_signature(out, signature));
//
//        const auto result = encode_base16(out);
//        BOOST_REQUIRE_EQUAL(result, DER_SIGNATURE3);
//    }

//    BOOST_AUTO_TEST_CASE(elliptic_curve__sign__positive__test)
//    {
//        ec_signature signature;
//        const ec_secret secret = hash_literal(SECRET3);
//        const hash_digest sighash = hash_literal(SIGHASH3);
//        BOOST_REQUIRE(sign(signature, secret, sighash));
//
//        const auto result = encode_base16(signature);
//        BOOST_REQUIRE_EQUAL(result, EC_SIGNATURE3);
//    }
