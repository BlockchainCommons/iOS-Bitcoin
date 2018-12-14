//
//  TestRandom.swift
//  Bitcoin_Tests
//
//  Created by Wolf McNally on 10/28/18.
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
import WolfNumerics

class TestRandom: XCTestCase {
    func testSeed() {
        var rng = SeededRandomNumberGenerator(seed: 1)
        let data = seed(count: 10, using: &rng)
        XCTAssert(data |> toBase16 == "610d61f11a62b17cd484")
        let bip39seed = seed(bits: 512, using: &rng)
        XCTAssert(bip39seed |> toBase16 == "ff2a8b2622253ea52073d2798bf1880ef7f97047cbc41e00f9c9a5b3fa76f263a913c5a78ed3ed208a1a3356294cc535e35e526c2866451d61f2995df29d6137")
    }

    func testSeed2() {
        let data = seed()
        XCTAssertEqual(data.count, minimumSeedSize)
    }

    func testSeed3() {
        let data = seed(bits: 9)
        XCTAssertEqual(data.count, 2)
    }
}
