//
//  TestScript.swift
//  Bitcoin_Tests
//
//  Created by Wolf McNally on 11/7/18.
//  Copyright © 2018 Blockchain Commons. All rights reserved.
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

class TestScript: XCTestCase {
    func testScriptDecode() {
        let f = base16Decode >>> scriptDecode
        XCTAssert(try! "76a91418c0bd8d1818f1bf99cb1df2269c645318ef7b7388ac" |> f == "dup hash160 [18c0bd8d1818f1bf99cb1df2269c645318ef7b73] equalverify checksig")
        XCTAssert(try! "04cf2e5b02d6f02340f5a9defbbf710c388b8451c82145b1419fe9696837b1cdefc569a2a79baa6da2f747c3b35a102a081dfd5e799abc41262103e0d17114770b" |> f == "[cf2e5b02] 0xd6 0xf0 [40f5a9defbbf710c388b8451c82145b1419fe9696837b1cdefc569a2a79baa6da2f747] 0xc3 nop4 10 [2a081dfd5e799abc41262103e0d17114] nip <invalid>")
        XCTAssert(try! "4730440220688fb2aef767f21127b375d50d0ab8f7a1abaecad08e7c4987f7305c90e5a02502203282909b7863149bf4c92589764df80744afb509b949c06bfbeb28864277d88d0121025334b571c11e22967452f195509260f6a6dd10357fc4ad76b1c0aa5981ac254e" |> f == "[30440220688fb2aef767f21127b375d50d0ab8f7a1abaecad08e7c4987f7305c90e5a02502203282909b7863149bf4c92589764df80744afb509b949c06bfbeb28864277d88d01] [025334b571c11e22967452f195509260f6a6dd10357fc4ad76b1c0aa5981ac254e]")
        XCTAssert(try! "" |> f == "")
    }

    func testScriptEncode() {
        let f = scriptEncode >>> base16Encode
        XCTAssert(try! "dup hash160 [18c0bd8d1818f1bf99cb1df2269c645318ef7b73] equalverify checksig" |> f == "76a91418c0bd8d1818f1bf99cb1df2269c645318ef7b7388ac")
        XCTAssertThrowsError(try "foo" |> f == "won't happen") // Invalid script
        XCTAssert(try! "" |> f == "")
    }
}
