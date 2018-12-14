//
//  TestOutputPoint.swift
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
import WolfFoundation

class TestOutputPoint: XCTestCase {
    func test1() {
        let outputPoint = OutputPoint()
        XCTAssertFalse(outputPoint.isValid)
    }

    func test2() {
        let hash = try! "000000000019d6689c085ae165831e934ff763ae46a2a6c172b3f1b60a8ce26f" |> dataLiteral |> tagHashDigest
        let index: UInt32 = 1234
        let outputPoint = OutputPoint(hash: hash, index: index)
        XCTAssert(outputPoint.isValid)

        let outputPoint2 = outputPoint
        XCTAssert(outputPoint == outputPoint2)
        XCTAssert(outputPoint2.hash == hash)
        XCTAssert(outputPoint2.index == index)
    }

    func test3() {
        let data = "10" |> dataLiteral
        XCTAssertThrowsError(try data |> deserializeOutputPoint)
    }

    func test4() {
        let index: UInt32 = 53213
        let hash = try! "11121314151617180101ab1111cd1111011011ab1111cd1101111111ab1111cd" |> dataLiteral |> tagHashDigest
        let initial = OutputPoint(hash: hash, index: index)
        XCTAssert(initial.isValid)
        XCTAssertEqual(initial.hash, hash)
        XCTAssertEqual(initial.index, index)


        XCTAssertEqual(initial.description, """
        {"hash":"11121314151617180101ab1111cd1111011011ab1111cd1101111111ab1111cd","index":53213}
        """)

        var point = OutputPoint()
        XCTAssertFalse(initial == point)

        point = try! initial |> serialize |> deserializeOutputPoint
        XCTAssert(point.isValid)
        XCTAssert(initial == point)
    }

    func test5() {
        let data = "46682488f0a721124a3905a1bb72445bf13493e2cd46c5c0c8db1c15afa0d58e00000000" |> dataLiteral
        let point = try! data |> deserializeOutputPoint
        XCTAssert(point.isValid)
        XCTAssertEqual(point.hash |> hashEncode, "8ed5a0af151cdbc8c0c546cde29334f15b4472bba105394a1221a7f088246846")
        XCTAssertEqual(point.index, 0)
        XCTAssertEqual(point |> serialize, data)
    }
}

