//
//  TestHash.swift
//  Bitcoin_Tests
//
//  Created by Wolf McNally on 10/25/18.
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

class TestHash: XCTestCase {
    func testHash() {
        let message = "The quick brown 🦊 jumps over the lazy 🐶." |> toUTF8
        XCTAssert(message |> toRIPEMD160 |> rawValue |> toBase16 == "8099ed424ffa0d81a42f75b61aff1f22ef7bfd11")
        XCTAssert(message |> toSHA160 |> rawValue |> toBase16 == "0c248790270625fabd126d61bffb78625bf191c7")
        XCTAssert(message |> toSHA256 |> rawValue |> toBase16 == "b34ae13c097ec7a206b515b0cc3ff4b2c2f4e0fce30298604be140cdc7a76b74")
        XCTAssert(message |> toSHA512 |> rawValue |> toBase16 == "a26171d120b6e921e28c98c94a8a9ef540bb642b1da24b7aed830401d180ee62f2297a0f91f6b218539f04ae8db70779e7241e66e9d92f97bf75d20d6b23720a")
        XCTAssert(message |> toBitcoin256 |> rawValue |> toBase16 == "032ba0f612f1564b19df42bbb611f6ca0bbc2a5a7553e576babeb5f88429cb2a")
        XCTAssert(message |> toBitcoin160 |> rawValue |> toBase16 == "87c1d0bb4d6148c837463b3bedc72c260d2dcff5")

        let key = "secret" |> toUTF8
        XCTAssert(message |> toSHA256HMAC(key: key) |> rawValue |> toBase16 == "16a1b60714655152de8b7360422b4843aaa6d603882295a87ef316ef1c297be9")
        XCTAssert(message |> toSHA512HMAC(key: key) |> rawValue |> toBase16 == "1bd5a8a845dae3b4b5cd125d77336d3d0b899b78e7446788942849d61e9b221caf4d79d39ac1b3fbc9edee3743cbfcda693b1d76015ee771d99f1284b22cdfe1")

        let passphrase = "password" |> toUTF8
        let salt = "salt" |> toUTF8
        let data: Base16 = "fef7276b107040a0a713bcbec9fd3e191cc6153249e245a3e1a22087dbe616060bbfc8411c6363f3c10ab5d02a56c38e2066a4e205b0ca8f959fd731e5fa584b"
        XCTAssert(passphrase |> toPKCS5PBKDF2HMACSHA512(salt: salt, iterations: 100) |> rawValue |> toBase16 == data)
    }
}
