//
//  TestSSS.swift
//  Bitcoin_Example
//
//  Created by Wolf McNally on 2/20/19.
//  Copyright © 2019 Blockchain Commons. All rights reserved.
//

import XCTest
import Bitcoin
import WolfPipe
import WolfFoundation

class TestSSS: XCTestCase {
    func testRandomBytes() {
        let bytes1 = randomBytes(count: 64)
        XCTAssertEqual(bytes1.count, 64)
        let bytes2 = randomBytes(count: 64)
        XCTAssertNotEqual(bytes1, bytes2)
    }
}
