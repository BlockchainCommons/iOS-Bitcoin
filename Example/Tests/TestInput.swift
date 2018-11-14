//
//  TestInput.swift
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

class TestInput: XCTestCase {

    let validRawInput = try! ("54b755c39207d443fd96a8d12c94446a1c6f66e39c95e894c23418d7501f681b01000" +
        "0006b48304502203267910f55f2297360198fff57a3631be850965344370f732950b4" +
        "7795737875022100f7da90b82d24e6e957264b17d3e5042bab8946ee5fc676d15d915" +
        "da450151d36012103893d5a06201d5cf61400e96fa4a7514fc12ab45166ace618d68b" +
        "8066c9c585f9ffffffff") |> base16Decode

    func test1() {
        let input = Input()
        XCTAssertFalse(input.isValid)
    }
}
