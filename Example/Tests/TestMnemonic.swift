//
//  TestMnemonic.swift
//  Bitcoin_Tests
//
//  Created by Wolf McNally on 10/29/18.
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
import WolfStrings

class TestMnemonic: XCTestCase {
    func testNewMnemonic() {
        func test(_ seed: String, _ language: Language, _ mnemonic: String) -> Bool {
            let a = seed
            return try! a |> dataLiteral |> newMnemonic(language: language) |> rawValue == mnemonic
        }

        XCTAssert(test("baadf00dbaadf00d", .en, "rival hurdle address inspire tenant alone"))
        XCTAssert(test("baadf00dbaadf00dbaadf00dbaadf00d", .en, "rival hurdle address inspire tenant almost turkey safe asset step lab boy"))
        XCTAssertThrowsError(try "baadf00dbaadf00dbaadf00dbaadf00dff" |> dataLiteral |> newMnemonic(language: .en) == "won't happen") // Invalid seed size
        XCTAssert(test("7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f", .en, "legal winner thank year wave sausage worth useful legal winner thank yellow"))
        XCTAssert(test("baadf00dbaadf00dbaadf00dbaadf00d", .es, "previo humilde actuar jarabe tabique ahorro tope pulpo anís señal lavar bahía"))

        XCTAssert(test("baadf00dbaadf00dbaadf00dbaadf00d", .fr, "placard garantir acerbe gratuit soluble affaire théorie ponctuel anguleux salon horrible bateau"))
        XCTAssert(test("baadf00dbaadf00dbaadf00dbaadf00d", .it, "rizoma lastra affabile lucidato sultano algebra tramonto rupe annuncio sonda mega bavosa"))
        XCTAssert(test("baadf00dbaadf00dbaadf00dbaadf00d", .ja, "ねんかん すずしい あひる せたけ ほとんど あんまり めいあん のべる いなか ふとる ぜんりゃく えいせい"))
        XCTAssert(test("baadf00dbaadf00dbaadf00dbaadf00d", .cs, "semeno mudrc babka nasekat uvolnit bazuka vydra skanzen broskev trefit nuget datel"))
        XCTAssert(test("baadf00dbaadf00dbaadf00dbaadf00d", .ru, "ремарка кривой айсберг лауреат тротуар амнезия фонтан рояль бакалея сухой магазин бунт"))
        XCTAssert(test("baadf00dbaadf00dbaadf00dbaadf00d", .uk, "сержант ледачий актив люкс фах арена цемент слон бесіда тротуар мандри верба"))
        XCTAssert(test("baadf00dbaadf00dbaadf00dbaadf00d", .zh_Hans, "博 肉 地 危 惜 多 陪 荒 因 患 伊 基"))
        XCTAssert(test("baadf00dbaadf00dbaadf00dbaadf00d", .zh_Hant, "博 肉 地 危 惜 多 陪 荒 因 患 伊 基"))
    }

    func testMnemonicToSeed() {
        func test(_ m: String, seed: String) -> Bool {
            return try! m |> mnemonic |> mnemonicToSeed |> toBase16 |> rawValue == seed
        }

        XCTAssert(test("rival hurdle address inspire tenant alone", seed: "33498afc5ef71e87afd7cad1e50a9d9adb9e30d3ca4b1da5dc370d266aa7796cbc1854eebce5ab3fd3b02b6625e2a82868dbb693e988e47d74106f04c76a6263"))
    }

    func testMnemonicToSeedWithPassphrase() {
        func test(_ m: String, passphrase: String, seed: String) -> Bool {
            return try! m |> mnemonic |> mnemonicToSeedWithPassphrase(passphrase) |> toBase16 |> rawValue == seed
        }

        XCTAssert(test("legal winner thank year wave sausage worth useful legal winner thank yellow", passphrase: "TREZOR", seed: "2e8905819b8723fe2c1d161860e5ee1830318dbf49a83bd451cfb8440c28bd6fa457fe1296106559a3c80937a1c1069be3a3a5bd381ee6260e8d9739fce1f607"))
        XCTAssert(test("legal winner thank year wave sausage worth useful legal winner thank yellow", passphrase: "博 肉 地 危 惜 多 陪 荒 因 患 伊 基", seed: "3e52585ea1275472a82fa0dcd84121e742140f64a302eca7c390832ba428c707a7ebf449267ae592c51f1740259226e31520de39fd8f33e08788fd21221c6f4e"))
        XCTAssert(test("previo humilde actuar jarabe tabique ahorro tope pulpo anís señal lavar bahía", passphrase: "博 肉 地 危 惜 多 陪 荒 因 患 伊 基", seed: "e72505021b97e15171fe09e996898888579c4196c445d7629762c5b09586e3fb3d68380120b8d8a6ed6f9a73306dab7bf54127f3a610ede2a2d5b4e59916ac73"))
    }
}
