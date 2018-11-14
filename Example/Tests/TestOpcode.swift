//
//  TestOpcode.swift
//  Bitcoin_Tests
//
//  Created by Wolf McNally on 11/12/18.
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

class TestOpcode: XCTestCase {
    func testToString1() {
        func f(_ op: Opcode, _ expected: String) -> Bool {
            return op |> toString(rules: .allRules) == expected
                && op |> toString(rules: .noRules) == expected
        }

        XCTAssert(f(.pushSize0, "zero"))
        XCTAssert(f(.pushSize42, "push_42"))
        XCTAssert(f(.pushOneSize, "pushdata1"))
        XCTAssert(f(.pushTwoSize, "pushdata2"))
        XCTAssert(f(.pushFourSize, "pushdata4"))
        XCTAssert(f(.reserved80, "reserved"))
        XCTAssert(f(.pushPositive7, "7"))
        XCTAssert(f(.reserved98, "ver"))
        XCTAssert(f(.reserved186, "0xba"))
        XCTAssert(f(.reserved255, "0xff"))
    }

    func testToString2() {
        XCTAssert(Opcode.checklocktimeverify |> toString(rules: .noRules) == "nop2")
        XCTAssert(Opcode.checklocktimeverify |> toString(rules: .bip65Rule) == "checklocktimeverify")

        XCTAssert(Opcode.checksequenceverify |> toString(rules: .noRules) == "nop3")
        XCTAssert(Opcode.checksequenceverify |> toString(rules: .bip112Rule) == "checksequenceverify")
    }

    func testToOpcode() {
        func f(_ s: String, _ op: Opcode) -> Bool {
            return try! s |> toOpcode == op
        }

        // zero
        XCTAssert(f("zero", .pushSize0))
        XCTAssert(f("push_0", .pushSize0))
        XCTAssert(f("0", .pushSize0))

        // push n (special)
        XCTAssert(f("push_1", .pushSize1))
        XCTAssert(f("push_75", .pushSize75))

        // push n byte size (pushdata)
        XCTAssert(f("push_one", .pushOneSize))
        XCTAssert(f("pushdata1", .pushOneSize))

        XCTAssert(f("push_two", .pushTwoSize))
        XCTAssert(f("pushdata2", .pushTwoSize))

        XCTAssert(f("push_four", .pushFourSize))
        XCTAssert(f("pushdata4", .pushFourSize))
    }

    func testToHexadecimal() {
        XCTAssert(Opcode.pushSize0 |> toHexadecimal == "0x00")
        XCTAssert(Opcode.pushSize42 |> toHexadecimal == "0x2a")
        XCTAssert(Opcode.reserved255 |> toHexadecimal == "0xff")
    }

    func testHexadecimalToOpcode() {
        XCTAssertThrowsError(try "" |> hexadecimalToOpcode)
        XCTAssertThrowsError(try "bogus" |> hexadecimalToOpcode)
        XCTAssertThrowsError(try "0x" |> hexadecimalToOpcode)
        XCTAssertThrowsError(try "0xf" |> hexadecimalToOpcode)
        XCTAssertThrowsError(try "0xffe" |> hexadecimalToOpcode)
        XCTAssertThrowsError(try "0xffee" |> hexadecimalToOpcode)
        XCTAssertThrowsError(try "0X4f" |> hexadecimalToOpcode)
        XCTAssertThrowsError(try "42" |> hexadecimalToOpcode)
        XCTAssert(try! "0xff" |> hexadecimalToOpcode == .reserved255)
        XCTAssert(try! "0xFE" |> hexadecimalToOpcode == .reserved254)
        XCTAssert(try! "0xFe" |> hexadecimalToOpcode == .reserved254)
        XCTAssert(try! "0x42" |> hexadecimalToOpcode == .pushSize66)
        XCTAssert(try! "0x4f" |> hexadecimalToOpcode == .pushNegative1)
    }
}
