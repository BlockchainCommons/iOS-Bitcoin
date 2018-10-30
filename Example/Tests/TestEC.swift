//
//  TestEC.swift
//  Bitcoin_Tests
//
//  Created by Wolf McNally on 10/30/18.
//  Copyright © 2018 Blockchain Commons. All rights reserved.
//

import XCTest
import Bitcoin
import WolfPipe
import WolfStrings

class TestEC: XCTestCase {
    func testECNew() {
        XCTAssertNoThrow(try "baadf00dbaadf00dbaadf00dbaadf00d" |> fromHex |> ecNew |> toHex == "8ed1d17dabce1fccbbe5e9bf008b318334e5bcc78eb9e7c1ea850b7eb0ddb9c8")
        XCTAssertThrowsError(try "baadf00dbaadf00d" |> fromHex |> ecNew |> toHex == "won't happen") // seed too short
    }
}
