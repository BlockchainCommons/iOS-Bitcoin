//
//  TestWrapped.swift
//  Bitcoin_Tests
//
//  Created by Wolf McNally on 11/6/18.
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

class TestWrapped: XCTestCase {
    func testWrapEncode() {
        let f = { base16 >>> toData >>> wrapEncode(version: $0) >>> toBase16 }
        XCTAssert(try! "031bab84e687e36514eeaf5a017c30d32c1f59dd4ea6629da7970ca374513dd006" |> f(0) == "00031bab84e687e36514eeaf5a017c30d32c1f59dd4ea6629da7970ca374513dd0065b09d03c")
        XCTAssert(try! "031bab84e687e36514eeaf5a017c30d32c1f59dd4ea6629da7970ca374513dd006" |> f(42) == "2a031bab84e687e36514eeaf5a017c30d32c1f59dd4ea6629da7970ca374513dd006298eebe4")
    }

    func testWrapDecode() {
        let f = base16 >>> toData >>> wrapDecode >>> toJSONStringWithOutputFormatting(.sortedKeys)
        XCTAssert(try! "00031bab84e687e36514eeaf5a017c30d32c1f59dd4ea6629da7970ca374513dd0065b09d03c" |> f == """
            {"checksum":1020266843,"payload":"031bab84e687e36514eeaf5a017c30d32c1f59dd4ea6629da7970ca374513dd006","prefix":0}
            """)
        XCTAssert(try! "2a031bab84e687e36514eeaf5a017c30d32c1f59dd4ea6629da7970ca374513dd006298eebe4" |> f == """
            {"checksum":3840642601,"payload":"031bab84e687e36514eeaf5a017c30d32c1f59dd4ea6629da7970ca374513dd006","prefix":42}
            """)
    }
}
