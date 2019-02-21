//
//  TestSSS.swift
//  Bitcoin_Example
//
//  Created by Wolf McNally on 10/24/18.
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

class TestSSS: XCTestCase {
    func testRandomBytes() throws {
        let bytes1 = try SSS.randomBytes(count: 64)
        XCTAssertEqual(bytes1.count, 64)
        let bytes2 = try SSS.randomBytes(count: 64)
        XCTAssertNotEqual(bytes1, bytes2)
    }

    func testSSS() throws {
        let message = try SSSMessage(rawValue: SSS.randomBytes(count: SSSMessage.length))!

        func test(shareCount: Int, quorum: Int, retrievedCount: Int) throws -> Bool {
            let shares = SSS.createShares(from: message, shareCount: shareCount, quorum: quorum)
            let encodedShares = shares.map { $0.base64 }
            let retrievedShares = Array(encodedShares.shuffled()[0..<retrievedCount])
            let decodedRetrievedShares = try retrievedShares.map { try SSSShare(base64: $0) }
            let retrievedMessage = SSS.combineShares(decodedRetrievedShares)
            return message == retrievedMessage
        }

        XCTAssertTrue(try test(shareCount: 3, quorum: 2, retrievedCount: 2))
        XCTAssertFalse(try test(shareCount: 3, quorum: 2, retrievedCount: 1))
        XCTAssertFalse(try test(shareCount: 3, quorum: 2, retrievedCount: 0))

        XCTAssertTrue(try test(shareCount: 7, quorum: 5, retrievedCount: 7))
        XCTAssertTrue(try test(shareCount: 7, quorum: 5, retrievedCount: 6))
        XCTAssertTrue(try test(shareCount: 7, quorum: 5, retrievedCount: 5))
        XCTAssertFalse(try test(shareCount: 7, quorum: 5, retrievedCount: 4))
        XCTAssertFalse(try test(shareCount: 7, quorum: 5, retrievedCount: 3))
        XCTAssertFalse(try test(shareCount: 7, quorum: 5, retrievedCount: 2))
        XCTAssertFalse(try test(shareCount: 7, quorum: 5, retrievedCount: 1))
        XCTAssertFalse(try test(shareCount: 7, quorum: 5, retrievedCount: 0))
    }
}
