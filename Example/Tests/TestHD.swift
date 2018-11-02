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
    let key1 = "xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi"
    let key2 = "xprv9uHRZZhk6KAJC1avXpDAp4MDc3sQKNxDiPvvkX8Br5ngLNv1TxvUxt4cV1rGL5hj6KCesnDYUhd7oWgT11eZG7XnxHrnYeSvkzY7d2bhkJ7"
    let key3 = "xprv9wTYmMFdV23N2TdNG573QoEsfRrWKQgWeibmLntzniatZvR9BmLnvSxqu53Kw1UmYPxLgboyZQaXwTCg8MSY3H2EU4pWcQDnRnrVA1xe8fs"
    let key4 = "xprv9z4pot5VBttmtdRTWfWQmoH1taj2axGVzFqSb8C9xaxKymcFzXBDptWmT7FwuEzG3ryjH4ktypQSAewRiNMjANTtpgP4mLTj34bhnZX7UiM"
    let key5 = "xprvA2JDeKCSNNZky6uBCviVfJSKyQ1mDYahRjijr5idH2WwLsEd4Hsb2Tyh8RfQMuPh7f7RtyzTtdrbdqqsunu5Mm3wDvUAKRHSC34sJ7in334"
    let key6 = "xprvA41z7zogVVwxVSgdKUHDy1SKmdb533PjDz7J6N6mV6uS3ze1ai8FHa8kmHScGpWmj4WggLyQjgPie1rFSruoUihUZREPSL39UNdE3BBDu76"

    let key7 = "xprv9s21ZrQH143K31xYSDQpPDxsXRTUcvj2iNHm5NUtrGiGG5e2DtALGdso3pGz6ssrdK4PFmM8NSpSBHNqPqm55Qn3LqFtT2emdEXVYsCzC2U"
    let key8 = "xprv9vHkqa6EV4sPZHYqZznhT2NPtPCjKuDKGY38FBWLvgaDx45zo9WQRUT3dKYnjwih2yJD9mkrocEZXo1ex8G81dwSM1fwqWpWkeS3v86pgKt"
    let key9 = "xprv9wSp6B7kry3Vj9m1zSnLvN3xH8RdsPP1Mh7fAaR7aRLcQMKTR2vidYEeEg2mUCTAwCd6vnxVrcjfy2kRgVsFawNzmjuHc2YmYRmagcEPdU9"
    let key10 = "xprv9zFnWC6h2cLgpmSA46vutJzBcfJ8yaJGg8cX1e5StJh45BBciYTRXSd25UEPVuesF9yog62tGAQtHjXajPPdbRCHuWS6T8XA2ECKADdw4Ef"
    let key11 = "xprvA1RpRA33e1JQ7ifknakTFpgNXPmW2YvmhqLQYMmrj4xJXXWYpDPS3xz7iAxn8L39njGVyuoseXzU6rcxFLJ8HFsTjSyQbLYnMpCqE2VbFWc"
    let key12 = "xprvA2nrNbFZABcdryreWet9Ea4LvTJcGsqrMzxHx98MMrotbir7yrKCEXw7nadnHM8Dq38EGfSh6dqA9QWTyefMLEcBYJUuekgW4BYPJcr9E7j"

    let key13 = "tprv8ZgxMBicQKsPeQXeTomURYYS8ZhysPog3wXLPwStJ9LeiPeGvypYe4y6HhWadxZi4BB2dLSAMXVkoRi8AoeNXmjETeYFiyRi56BhFnkm9uh"
    let key14 = "tprv8ceMhknangxznNWYWLbRe6ovqv4rPkrnv61XEwfaoaXwHtPQVT8Rg4PUQaGuuHCEyRC4bAthkWKmmKGML38nCcn7sEZ4v1Cw5Ar6TP63QcC"

    func testHDNew() {
        func test(seed: String, version: UInt32, expected: String) throws -> Bool {
            let version: UInt32 = 76066276
            let seedData = try! seed |> base16Decode
            return try seedData |> newHDPrivateKey(version: version) == expected
        }

        let mainnetVersion: UInt32 = 76066276
        let testnetVersion: UInt32 = 70615956

        XCTAssertNoThrow(try test(seed: "000102030405060708090a0b0c0d0e0f", version: mainnetVersion, expected: key1))
        XCTAssertNoThrow(try test(seed: "fffcf9f6f3f0edeae7e4e1dedbd8d5d2cfccc9c6c3c0bdbab7b4b1aeaba8a5a29f9c999693908d8a8784817e7b7875726f6c696663605d5a5754514e4b484542", version: mainnetVersion, expected: "xprv9s21ZrQH143K31xYSDQpPDxsXRTUcvj2iNHm5NUtrGiGG5e2DtALGdso3pGz6ssrdK4PFmM8NSpSBHNqPqm55Qn3LqFtT2emdEXVYsCzC2U"))
        XCTAssertNoThrow(try test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", version: mainnetVersion, expected: "xprv9s21ZrQH143K3bJ7oEuyFtvSpSHmdsmfiPcDXX2RpArAvnuBwcUo8KbeNXLvdbBPgjeFdEpQCAuxLaAP3bJRiiTdw1Kx4chf9zSGp95KBBR"))
        XCTAssertNoThrow(try test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", version: testnetVersion, expected: "tprv8ZgxMBicQKsPeQXeTomURYYS8ZhysPog3wXLPwStJ9LeiPeGvypYe4y6HhWadxZi4BB2dLSAMXVkoRi8AoeNXmjETeYFiyRi56BhFnkm9uh"))
        XCTAssertThrowsError(try test(seed: "baadf00dbaadf00d", version: mainnetVersion, expected: "throws")) // short seed
    }

    func testDeriveHDPrivateKey() {
        XCTAssertNoThrow(try key1 |> deriveHDPrivateKey(index: 0, isHardened: true) == key2)
        XCTAssertNoThrow(try key2 |> deriveHDPrivateKey(index: 1, isHardened: false) == key3)
        XCTAssertNoThrow(try key3 |> deriveHDPrivateKey(index: 2, isHardened: true) == key4)
        XCTAssertNoThrow(try key4 |> deriveHDPrivateKey(index: 2, isHardened: false) == key5)
        XCTAssertNoThrow(try key5 |> deriveHDPrivateKey(index: 1000000000, isHardened: false) == key6)

        XCTAssertNoThrow(try key7 |> deriveHDPrivateKey(index: 0, isHardened: false) == key8)
        XCTAssertNoThrow(try key8 |> deriveHDPrivateKey(index: 2147483647, isHardened: true) == key9)
        XCTAssertNoThrow(try key9 |> deriveHDPrivateKey(index: 1, isHardened: false) == key10)
        XCTAssertNoThrow(try key10 |> deriveHDPrivateKey(index: 2147483646, isHardened: true) == key11)
        XCTAssertNoThrow(try key10 |> deriveHDPrivateKey(index: 2147483646, isHardened: true) == key11)
        XCTAssertNoThrow(try key11 |> deriveHDPrivateKey(index: 2, isHardened: false) == key12)

        XCTAssertNoThrow(try key13 |> deriveHDPrivateKey(index: 1, isHardened: false) == key14)

        XCTAssertThrowsError(try "foobar" |> deriveHDPrivateKey(index: 1, isHardened: false) == key14) // Bad parent key
    }
}
