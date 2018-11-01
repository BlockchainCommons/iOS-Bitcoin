//
//  TestHD.swift
//  Bitcoin_Example
//
//  Created by Wolf McNally on 10/29/18.
//  Copyright © 2018 Blockchain Commons. All rights reserved.
//

import XCTest
import Bitcoin
import WolfPipe
import WolfStrings

class TestHD: XCTestCase {
    func testHDNew() {
        func test(seed: String, version: UInt32, expected: String) throws -> Bool {
            let version: UInt32 = 76066276
            let seedData = try! seed |> base16Decode
            return try seedData |> hdNew(version: version) == expected
        }

        let mainnetVersion: UInt32 = 76066276
        let testnetVersion: UInt32 = 70615956

        XCTAssertNoThrow(try test(seed: "000102030405060708090a0b0c0d0e0f", version: mainnetVersion, expected: "xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi"))
        XCTAssertNoThrow(try test(seed: "fffcf9f6f3f0edeae7e4e1dedbd8d5d2cfccc9c6c3c0bdbab7b4b1aeaba8a5a29f9c999693908d8a8784817e7b7875726f6c696663605d5a5754514e4b484542", version: mainnetVersion, expected: "xprv9s21ZrQH143K31xYSDQpPDxsXRTUcvj2iNHm5NUtrGiGG5e2DtALGdso3pGz6ssrdK4PFmM8NSpSBHNqPqm55Qn3LqFtT2emdEXVYsCzC2U"))
        XCTAssertNoThrow(try test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", version: mainnetVersion, expected: "xprv9s21ZrQH143K3bJ7oEuyFtvSpSHmdsmfiPcDXX2RpArAvnuBwcUo8KbeNXLvdbBPgjeFdEpQCAuxLaAP3bJRiiTdw1Kx4chf9zSGp95KBBR"))
        XCTAssertNoThrow(try test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", version: testnetVersion, expected: "tprv8ZgxMBicQKsPeQXeTomURYYS8ZhysPog3wXLPwStJ9LeiPeGvypYe4y6HhWadxZi4BB2dLSAMXVkoRi8AoeNXmjETeYFiyRi56BhFnkm9uh"))
        XCTAssertThrowsError(try test(seed: "baadf00dbaadf00d", version: mainnetVersion, expected: "throws")) // short seed
    }
}
