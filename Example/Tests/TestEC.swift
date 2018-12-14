//
//  TestEC.swift
//  Bitcoin_Tests
//
//  Created by Wolf McNally on 10/30/18.
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

class TestEC: XCTestCase {
    func testECPrivateKeyNew() {
        let f = tagBase16 >>> toData >>> newECPrivateKey >>> rawValue >>> toBase16
        XCTAssert(try! "baadf00dbaadf00dbaadf00dbaadf00d" |> f == "8ed1d17dabce1fccbbe5e9bf008b318334e5bcc78eb9e7c1ea850b7eb0ddb9c8")
        XCTAssertThrowsError(try "baadf00dbaadf00d" |> f == "won't happen") // seed too short
    }

    func testToECPublicKey() {
        let f = { tagBase16 >>> toData >>> toECPrivateKey >>> toECPublicKey(isCompressed: $0) >>> rawValue >>> toBase16 }
        XCTAssert(try! "4c721ccd679b817ea5e86e34f9d46abb1660a63955dde908702214eaab038475" |> f(true) == "03ac9e60013853128b42a1324609bac2ccff6a0b4844b6301f1f552e15ee14c7a5")
        XCTAssert(try! "8ed1d17dabce1fccbbe5e9bf008b318334e5bcc78eb9e7c1ea850b7eb0ddb9c8" |> f(true) == "0247140d2811498679fe9a0467a75ac7aa581476c102d27377bc0232635af8ad36")
        XCTAssert(try! "8ed1d17dabce1fccbbe5e9bf008b318334e5bcc78eb9e7c1ea850b7eb0ddb9c8" |> f(false) == "0447140d2811498679fe9a0467a75ac7aa581476c102d27377bc0232635af8ad36e87bb04f401be3b770a0f3e2267a6c3b14a3074f6b5ce4419f1fcdc1ca4b1cb6")
    }

    func testToECPaymentAddress() {
        let f = { tagBase16 >>> toData >>> toECPublicKey >>> toECPaymentAddress(version: $0) }
        XCTAssert(try! "0247140d2811498679fe9a0467a75ac7aa581476c102d27377bc0232635af8ad36" |> f(.mainnetP2KH) == "1EKJFK8kBmasFRYY3Ay9QjpJLm4vemJtC1")
        XCTAssert(try! "0247140d2811498679fe9a0467a75ac7aa581476c102d27377bc0232635af8ad36" |> f(.testnetP2KH) == "mtqFYNDizo282Y29kjwXEf2dCkfdZZydbf")
        XCTAssert(try! "0447140d2811498679fe9a0467a75ac7aa581476c102d27377bc0232635af8ad36e87bb04f401be3b770a0f3e2267a6c3b14a3074f6b5ce4419f1fcdc1ca4b1cb6" |> f(.mainnetP2KH) == "197FLrycah42jKDgfmTaok7b8kNHA7R2ih")
        XCTAssert(try! "0447140d2811498679fe9a0467a75ac7aa581476c102d27377bc0232635af8ad36e87bb04f401be3b770a0f3e2267a6c3b14a3074f6b5ce4419f1fcdc1ca4b1cb6" |> f(.testnetP2KH) == "modCdv4bPiVHWRhJPLRxdfKuzjxz275cah")
    }

    func testToWIF() {
        let f = tagBase16 >>> toData >>> toECPrivateKey >>> toWIF
        let g = { tagBase16 >>> toData >>> toECPrivateKey >>> toWIF(network: .mainnet, isCompressed: $0) }
        XCTAssert(try! "8ed1d17dabce1fccbbe5e9bf008b318334e5bcc78eb9e7c1ea850b7eb0ddb9c8" |> f == "L21LJEeJwK35wby1BeTjwWssrhrgQE2MZrpTm2zbMC677czAHHu3")
        XCTAssert(try! "8ed1d17dabce1fccbbe5e9bf008b318334e5bcc78eb9e7c1ea850b7eb0ddb9c8" |> g(false) == "5JuBiWpsjfXNxsWuc39KntBAiAiAP2bHtrMGaYGKCppq4MuVcQL")
        XCTAssert(try! "0C28FCA386C7A227600B2FE50B7CAE11EC86D3BF1FBE471BE89827E19D72AA1D" |> g(false) == "5HueCGU8rMjxEXxiPuD5BDku4MkFqeZyd4dZ1jvhTVqvbTLvyTJ")
    }

    func testWIFToECPrivateKey() {
        let f = tagWIF >>> toECPrivateKey >>> rawValue >>> toBase16
        XCTAssert(try! "L21LJEeJwK35wby1BeTjwWssrhrgQE2MZrpTm2zbMC677czAHHu3" |> f == "8ed1d17dabce1fccbbe5e9bf008b318334e5bcc78eb9e7c1ea850b7eb0ddb9c8")
        XCTAssert(try! "5JuBiWpsjfXNxsWuc39KntBAiAiAP2bHtrMGaYGKCppq4MuVcQL" |> f == "8ed1d17dabce1fccbbe5e9bf008b318334e5bcc78eb9e7c1ea850b7eb0ddb9c8")
        XCTAssert(try! "5HueCGU8rMjxEXxiPuD5BDku4MkFqeZyd4dZ1jvhTVqvbTLvyTJ" |> f == "0c28fca386c7a227600b2fe50b7cae11ec86d3bf1fbe471be89827e19d72aa1d")
    }

    func testWIFToECPublicKey() {
        let f = tagWIF >>> toECPrivateKey >>> toECPublicKey >>> rawValue >>> toBase16
        let g = { tagWIF >>> toECPrivateKey >>> toECPublicKey(isCompressed: $0) >>> rawValue >>> toBase16 }
        XCTAssert(try! "L21LJEeJwK35wby1BeTjwWssrhrgQE2MZrpTm2zbMC677czAHHu3" |> f == "0247140d2811498679fe9a0467a75ac7aa581476c102d27377bc0232635af8ad36")
        XCTAssert(try! "5JuBiWpsjfXNxsWuc39KntBAiAiAP2bHtrMGaYGKCppq4MuVcQL" |> g(false) == "0447140d2811498679fe9a0467a75ac7aa581476c102d27377bc0232635af8ad36e87bb04f401be3b770a0f3e2267a6c3b14a3074f6b5ce4419f1fcdc1ca4b1cb6")
        XCTAssert(try! "5HueCGU8rMjxEXxiPuD5BDku4MkFqeZyd4dZ1jvhTVqvbTLvyTJ" |> g(false) == "04d0de0aaeaefad02b8bdc8a01a1b8b11c696bd3d66a2c5f10780d95b7df42645cd85228a6fb29940e858e7e55842ae2bd115d1ed7cc0e82d934e929c97648cb0a")
    }

    func testMessageSign() {
        XCTAssert("Nakomoto" |> toUTF8 |> signMessage(with: "KwE19y2Ud8EUEBjeUG4Uc4qWUJUUoZJxHR3xUfTpCSsJEDv2o8fu" |> tagWIF) == "HxQp3cXgOIhBEGXks27sfeSQHVgNUeYgl5i5wG/dOUYaSIRnnzXR6NcyH+AfNAHtkWcyOD9rX4pojqmuQyH79K4=")
        XCTAssert("Nakomoto" |> toUTF8 |> signMessage(with: "5HpMRgt5u8yyU1AfPwcgLGphD5Qu4ka4v7McE4jKrGNpQPyRqXC" |> tagWIF) == "GxQp3cXgOIhBEGXks27sfeSQHVgNUeYgl5i5wG/dOUYaSIRnnzXR6NcyH+AfNAHtkWcyOD9rX4pojqmuQyH79K4=")
    }

    func testMessageValidate() {
        // Compressed
        XCTAssert("Nakomoto" |> toUTF8 |> validateMessage(paymentAddress: "1PeChFbhxDD9NLbU21DfD55aQBC4ZTR3tE", signature: "HxQp3cXgOIhBEGXks27sfeSQHVgNUeYgl5i5wG/dOUYaSIRnnzXR6NcyH+AfNAHtkWcyOD9rX4pojqmuQyH79K4="))
        // Uncompressed
        XCTAssert("Nakomoto" |> toUTF8 |> validateMessage(paymentAddress: "1Em1SX7qQq1pTmByqLRafhL1ypx2V786tP", signature: "GxQp3cXgOIhBEGXks27sfeSQHVgNUeYgl5i5wG/dOUYaSIRnnzXR6NcyH+AfNAHtkWcyOD9rX4pojqmuQyH79K4="))
        // Compressed-invalid
        XCTAssertFalse("Satoshi" |> toUTF8 |> validateMessage(paymentAddress: "1PeChFbhxDD9NLbU21DfD55aQBC4ZTR3tE", signature: "HxQp3cXgOIhBEGXks27sfeSQHVgNUeYgl5i5wG/dOUYaSIRnnzXR6NcyH+AfNAHtkWcyOD9rX4pojqmuQyH79K4="))
    }

    func testECKeyHashable() {
        let key1 = ECPrivateKey()
        let key2 = ECPrivateKey()
        let s: Set<ECKey> = [key1, key2]
        XCTAssert(s.contains(key1))
        XCTAssert(s.contains(key2))
    }
}
