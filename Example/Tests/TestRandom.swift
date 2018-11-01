//
//  TestRandom.swift
//  Bitcoin_Tests
//
//  Created by Wolf McNally on 10/28/18.
//

import XCTest
import Bitcoin
import WolfPipe
import WolfStrings
import WolfNumerics

class TestRandom: XCTestCase {
    func testSeed() {
        var rng = SeededRandomNumberGenerator(seed: 1)
        let data = seed(count: 10, using: &rng)
        XCTAssert(try! data == "610d61f11a62b17cd484" |> base16Decode)
        let bip39seed = seed(bits: 512, using: &rng)
        XCTAssert(try! bip39seed == "ff2a8b2622253ea52073d2798bf1880ef7f97047cbc41e00f9c9a5b3fa76f263a913c5a78ed3ed208a1a3356294cc535e35e526c2866451d61f2995df29d6137" |> base16Decode)
    }
}
