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
        func test(seed: String, version: HDPrivateKeyVersion, expected: String) throws -> Bool {
            let seedData = try! seed |> base16Decode
            return try seedData |> newHDPrivateKey(version: version) == expected
        }

        XCTAssert(try! test(seed: "000102030405060708090a0b0c0d0e0f", version: .mainnet, expected: key1))
        XCTAssert(try! test(seed: "fffcf9f6f3f0edeae7e4e1dedbd8d5d2cfccc9c6c3c0bdbab7b4b1aeaba8a5a29f9c999693908d8a8784817e7b7875726f6c696663605d5a5754514e4b484542", version: .mainnet, expected: "xprv9s21ZrQH143K31xYSDQpPDxsXRTUcvj2iNHm5NUtrGiGG5e2DtALGdso3pGz6ssrdK4PFmM8NSpSBHNqPqm55Qn3LqFtT2emdEXVYsCzC2U"))
        XCTAssert(try! test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", version: .mainnet, expected: "xprv9s21ZrQH143K3bJ7oEuyFtvSpSHmdsmfiPcDXX2RpArAvnuBwcUo8KbeNXLvdbBPgjeFdEpQCAuxLaAP3bJRiiTdw1Kx4chf9zSGp95KBBR"))
        XCTAssert(try! test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", version: .testnet, expected: "tprv8ZgxMBicQKsPeQXeTomURYYS8ZhysPog3wXLPwStJ9LeiPeGvypYe4y6HhWadxZi4BB2dLSAMXVkoRi8AoeNXmjETeYFiyRi56BhFnkm9uh"))
        XCTAssertThrowsError(try test(seed: "baadf00dbaadf00d", version: .mainnet, expected: "throws")) // short seed
    }

    func testDeriveHDPrivateKey() {
        XCTAssert(try! key1 |> deriveHDPrivateKey(isHardened: true, index: 0) == key2)
        XCTAssert(try! key2 |> deriveHDPrivateKey(isHardened: false, index: 1) == key3)
        XCTAssert(try! key3 |> deriveHDPrivateKey(isHardened: true, index: 2) == key4)
        XCTAssert(try! key4 |> deriveHDPrivateKey(isHardened: false, index: 2) == key5)
        XCTAssert(try! key5 |> deriveHDPrivateKey(isHardened: false, index: 1000000000) == key6)

        XCTAssert(try! key7 |> deriveHDPrivateKey(isHardened: false, index: 0) == key8)
        XCTAssert(try! key8 |> deriveHDPrivateKey(isHardened: true, index: 2147483647) == key9)
        XCTAssert(try! key9 |> deriveHDPrivateKey(isHardened: false, index: 1) == key10)
        XCTAssert(try! key10 |> deriveHDPrivateKey(isHardened: true, index: 2147483646) == key11)
        XCTAssert(try! key10 |> deriveHDPrivateKey(isHardened: true, index: 2147483646) == key11)
        XCTAssert(try! key11 |> deriveHDPrivateKey(isHardened: false, index: 2) == key12)

        XCTAssert(try! key13 |> deriveHDPrivateKey(isHardened: false, index: 1) == key14)

        XCTAssertThrowsError(try "foobar" |> deriveHDPrivateKey(isHardened: false, index: 1) == key14) // Bad parent key
    }

    func testDeriveHDPublicKey() {
        XCTAssertThrowsError(try "xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8" |> deriveHDPublicKey(isHardened: true, index: 0) == key1)
        print(try! "xpub68Gmy5EdvgibQVfPdqkBBCHxA5htiqg55crXYuXoQRKfDBFA1WEjWgP6LHhwBZeNK1VTsfTFUHCdrfp1bgwQ9xv5ski8PX9rL2dZXvgGDnw" |> deriveHDPublicKey(isHardened: false, index: 1))
        XCTAssert(try! "xpub68Gmy5EdvgibQVfPdqkBBCHxA5htiqg55crXYuXoQRKfDBFA1WEjWgP6LHhwBZeNK1VTsfTFUHCdrfp1bgwQ9xv5ski8PX9rL2dZXvgGDnw" |> deriveHDPublicKey(isHardened: false, index: 2) == "xpub6ASuArnXKPbfEwhqN6e3mwBcDTgzisQN1wXN9BJcM47sSikHjJf3UFHKkNAWbWMiGj7Wf5uMash7SyYq527Hqck2AxYysAA7xmALppuCkwQ")
        XCTAssertThrowsError(try "xpub6ASuArnXKPbfEwhqN6e3mwBcDTgzisQN1wXN9BJcM47sSikHjJf3UFHKkNAWbWMiGj7Wf5uMash7SyYq527Hqck2AxYysAA7xmALppuCkwQ" |> deriveHDPublicKey(isHardened: true, index: 2) == key1)
        XCTAssert(try! "xpub6D4BDPcP2GT577Vvch3R8wDkScZWzQzMMUm3PWbmWvVJrZwQY4VUNgqFJPMM3No2dFDFGTsxxpG5uJh7n7epu4trkrX7x7DogT5Uv6fcLW5" |> deriveHDPublicKey(isHardened: false, index: 2) == "xpub6FHa3pjLCk84BayeJxFW2SP4XRrFd1JYnxeLeU8EqN3vDfZmbqBqaGJAyiLjTAwm6ZLRQUMv1ZACTj37sR62cfN7fe5JnJ7dh8zL4fiyLHV")
        XCTAssert(try! "xpub6FHa3pjLCk84BayeJxFW2SP4XRrFd1JYnxeLeU8EqN3vDfZmbqBqaGJAyiLjTAwm6ZLRQUMv1ZACTj37sR62cfN7fe5JnJ7dh8zL4fiyLHV" |> deriveHDPublicKey(isHardened: false, index: 1000000000) == "xpub6H1LXWLaKsWFhvm6RVpEL9P4KfRZSW7abD2ttkWP3SSQvnyA8FSVqNTEcYFgJS2UaFcxupHiYkro49S8yGasTvXEYBVPamhGW6cFJodrTHy")
    }
}
