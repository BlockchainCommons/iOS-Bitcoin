//
//  TestOperation.swift
//  Bitcoin_Tests
//
//  Created by Wolf McNally on 11/14/18.
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

class TestOperation: XCTestCase {
    func test1() {
        let operation = Bitcoin.Operation()
        XCTAssertFalse(operation.isValid)
        print(operation.data |> base16Encode)
        XCTAssert(operation.data.isEmpty)
        XCTAssert(operation.opcode == .disabledXor)
    }

    func test2() {
        let data = try! "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f" |> base16Decode
        let operation = try! Operation(data: data)
        XCTAssert(operation.isValid)
        XCTAssert(operation.opcode == .pushSize32)
        XCTAssert(operation.data == data)
    }

    func test3() {
        let data = try! "23156214" |> base16Decode
        let operation = try! Operation(data: data)
        XCTAssert(operation.isValid)
        let operation2 = operation
        XCTAssert(operation == operation2)
    }

    func test4() {
        let data = Data()
        XCTAssertThrowsError(try Operation.deserialize(data: data))
    }

    func test5() {
        let rawOperation = try! "00" |> base16Decode
        let operation = try! Operation.deserialize(data: rawOperation)
        XCTAssert(operation.isValid)
        XCTAssert(operation.serialized == rawOperation)

        let duplicate = try! Operation.deserialize(data: operation.serialized)
        XCTAssert(operation == duplicate)

        XCTAssert(operation.opcode == .pushSize0)
        XCTAssert(operation.data.isEmpty)
    }

    func test6() {
        let data75 = Data(repeating: ".".asciiByte, count: 75)
        let rawOperation = try! ("4b" |> base16Decode) + data75
        let operation = try! Operation.deserialize(data: rawOperation)
        XCTAssert(operation.isValid)
        XCTAssert(operation.serialized == rawOperation)

        let duplicate = try! Operation.deserialize(data: operation.serialized)
        XCTAssert(operation == duplicate)

        XCTAssert(operation.opcode == .pushSize75)
        XCTAssert(operation.data == data75)
    }

    func test7() {
        func f(_ opcode: Opcode, _ s: String) -> Bool {
            return opcode |> toOperation |> toString == s
        }
        XCTAssert(f(.pushSize0, "zero"))
        XCTAssert(f(.pushSize75, "push_75"))
        XCTAssert(f(.pushPositive7, "7"))
    }

    func test8() {
        XCTAssert(try! "07" |> base16Decode |> toOperation(isMinimal: true) |> toString == "7")
        XCTAssert(try! "07" |> base16Decode |> toOperation(isMinimal: false) |> toString == "[07]")
        XCTAssert(try! "42" |> base16Decode |> toOperation |> toString == "[42]")
        XCTAssert(try! "112233" |> base16Decode |> toOperation |> toString == "[112233]")
    }

    func test9() {
        XCTAssert(try! "03112233" |> base16Decode |> deserializeOperation |> toString == "[112233]")
        XCTAssert(try! "4c03112233" |> base16Decode |> deserializeOperation |> toString == "[1.112233]")
        XCTAssert(try! "4d0300112233" |> base16Decode |> deserializeOperation |> toString == "[2.112233]")
        XCTAssert(try! "4e03000000112233" |> base16Decode |> deserializeOperation |> toString == "[4.112233]")
    }

    func test10() {
        XCTAssert(Opcode.nop2 |> toString(rules: .noRules) == "nop2")
        XCTAssert(Opcode.nop2 |> toString(rules: .bip65Rule) == "checklocktimeverify")
        XCTAssert(Opcode.nop3 |> toString(rules: .noRules) == "nop3")
        XCTAssert(Opcode.nop3 |> toString(rules: .bip112Rule) == "checksequenceverify")
    }

    func test11() {
        func f(_ operationString: String, _ opcode: Opcode, _ dataString: String = "") -> Bool {
            let op = try! operationString |> toOperation
            let data = try! dataString |> base16Decode
            guard op.opcode == opcode else { return false }
            guard op.data == data else { return false }
            return true
        }

        XCTAssert(f("-1", .pushNegative1))
        XCTAssert(f("0", .pushSize0))
        XCTAssert(f("1", .pushPositive1))
        XCTAssert(f("16", .pushPositive16))

        XCTAssert(f("17", .pushSize1, "11"))
        XCTAssert(f("-2", .pushSize1, "82"))

        XCTAssert(f("9223372036854775807", .pushSize8, "ffffffffffffff7f"))
        XCTAssert(f("-9223372036854775807", .pushSize8, "ffffffffffffffff"))

        XCTAssert(f("''", .pushSize0))
        XCTAssert(f("'a'", .pushSize1, "61"))
        XCTAssert(f("'abc'", .pushSize3, "616263"))
        XCTAssert(f("'O'", .pushSize1, "4f"))

        XCTAssert(f("push_0", .pushSize0))
    }

    func test12() {
        XCTAssertThrowsError(try "push_1" |> toOperation)
        XCTAssertThrowsError(try "push_75" |> toOperation)
    }
}
