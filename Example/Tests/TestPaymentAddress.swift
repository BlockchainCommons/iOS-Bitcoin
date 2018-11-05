//
//  TestPaymentAddress.swift
//  Bitcoin_Tests
//
//  Created by Wolf McNally on 11/5/18.
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

class TestPaymentAddress: XCTestCase {
    func testAddressEncode() {
        let ripemd160 = try! "b472a266d0bd89c13706a4132ccfb16f7c3b9fcb" |> base16Decode
        XCTAssert(ripemd160 |> addressEncode == "1HT7xU2Ngenf7D4yocz2SAcnNLW7rK8d4E")
        XCTAssert(ripemd160 |> addressEncode(network: .testnet) == "mwy5FX7MVgDutKYbXBxQG5q7EL6pmhHT58")
    }

    func testAddressDecode() {
        let mainnetAddress = "1HT7xU2Ngenf7D4yocz2SAcnNLW7rK8d4E"
        let testnetAddress = "mwy5FX7MVgDutKYbXBxQG5q7EL6pmhHT58"

        XCTAssert(try! mainnetAddress |> addressDecode |> toJSON |> fromUTF8 == """
            {"checksum":2743498322,"payload":"b472a266d0bd89c13706a4132ccfb16f7c3b9fcb","prefix":0}
            """)
        XCTAssert(try! testnetAddress |> addressDecode |> toJSON |> fromUTF8 == """
            {"checksum":1475514977,"payload":"b472a266d0bd89c13706a4132ccfb16f7c3b9fcb","prefix":111}
            """)
    }
}
