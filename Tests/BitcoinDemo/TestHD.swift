//
//  TestHD.swift
//  Bitcoin_Example
//
//  Created by Wolf McNally on 10/29/18.
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
import WolfCore

class TestHD: XCTestCase {
    func testHDNew() {
        func test(seed: String, network: Network, expected: String) throws -> Bool {
            let seedData = seed |> dataLiteral
            let version = HDKeyVersion.findVersion(coinType: .btc, network: network, encoding: .p2pkh)!
            return try seedData |> newHDPrivateKey(hdKeyVersion: version) |> rawValue == expected
        }

        XCTAssert(try! test(seed: "000102030405060708090a0b0c0d0e0f", network: .mainnet, expected: "xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi"))
        XCTAssert(try! test(seed: "fffcf9f6f3f0edeae7e4e1dedbd8d5d2cfccc9c6c3c0bdbab7b4b1aeaba8a5a29f9c999693908d8a8784817e7b7875726f6c696663605d5a5754514e4b484542", network: .mainnet, expected: "xprv9s21ZrQH143K31xYSDQpPDxsXRTUcvj2iNHm5NUtrGiGG5e2DtALGdso3pGz6ssrdK4PFmM8NSpSBHNqPqm55Qn3LqFtT2emdEXVYsCzC2U"))
        XCTAssert(try! test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", network: .mainnet, expected: "xprv9s21ZrQH143K3bJ7oEuyFtvSpSHmdsmfiPcDXX2RpArAvnuBwcUo8KbeNXLvdbBPgjeFdEpQCAuxLaAP3bJRiiTdw1Kx4chf9zSGp95KBBR"))
        XCTAssert(try! test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", network: .testnet, expected: "tprv8ZgxMBicQKsPeQXeTomURYYS8ZhysPog3wXLPwStJ9LeiPeGvypYe4y6HhWadxZi4BB2dLSAMXVkoRi8AoeNXmjETeYFiyRi56BhFnkm9uh"))
        XCTAssertThrowsError(try test(seed: "baadf00dbaadf00d", network: .mainnet, expected: "throws")) // short seed
    }

    func testDeriveHDPrivateKey() {
        let key1: HDKey = "xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi"
        let key2: HDKey = "xprv9uHRZZhk6KAJC1avXpDAp4MDc3sQKNxDiPvvkX8Br5ngLNv1TxvUxt4cV1rGL5hj6KCesnDYUhd7oWgT11eZG7XnxHrnYeSvkzY7d2bhkJ7"
        let key3: HDKey = "xprv9wTYmMFdV23N2TdNG573QoEsfRrWKQgWeibmLntzniatZvR9BmLnvSxqu53Kw1UmYPxLgboyZQaXwTCg8MSY3H2EU4pWcQDnRnrVA1xe8fs"
        let key4: HDKey = "xprv9z4pot5VBttmtdRTWfWQmoH1taj2axGVzFqSb8C9xaxKymcFzXBDptWmT7FwuEzG3ryjH4ktypQSAewRiNMjANTtpgP4mLTj34bhnZX7UiM"
        let key5: HDKey = "xprvA2JDeKCSNNZky6uBCviVfJSKyQ1mDYahRjijr5idH2WwLsEd4Hsb2Tyh8RfQMuPh7f7RtyzTtdrbdqqsunu5Mm3wDvUAKRHSC34sJ7in334"
        let key6: HDKey = "xprvA41z7zogVVwxVSgdKUHDy1SKmdb533PjDz7J6N6mV6uS3ze1ai8FHa8kmHScGpWmj4WggLyQjgPie1rFSruoUihUZREPSL39UNdE3BBDu76"

        let key7: HDKey = "xprv9s21ZrQH143K31xYSDQpPDxsXRTUcvj2iNHm5NUtrGiGG5e2DtALGdso3pGz6ssrdK4PFmM8NSpSBHNqPqm55Qn3LqFtT2emdEXVYsCzC2U"
        let key8: HDKey = "xprv9vHkqa6EV4sPZHYqZznhT2NPtPCjKuDKGY38FBWLvgaDx45zo9WQRUT3dKYnjwih2yJD9mkrocEZXo1ex8G81dwSM1fwqWpWkeS3v86pgKt"
        let key9: HDKey = "xprv9wSp6B7kry3Vj9m1zSnLvN3xH8RdsPP1Mh7fAaR7aRLcQMKTR2vidYEeEg2mUCTAwCd6vnxVrcjfy2kRgVsFawNzmjuHc2YmYRmagcEPdU9"
        let key10: HDKey = "xprv9zFnWC6h2cLgpmSA46vutJzBcfJ8yaJGg8cX1e5StJh45BBciYTRXSd25UEPVuesF9yog62tGAQtHjXajPPdbRCHuWS6T8XA2ECKADdw4Ef"
        let key11: HDKey = "xprvA1RpRA33e1JQ7ifknakTFpgNXPmW2YvmhqLQYMmrj4xJXXWYpDPS3xz7iAxn8L39njGVyuoseXzU6rcxFLJ8HFsTjSyQbLYnMpCqE2VbFWc"
        let key12: HDKey = "xprvA2nrNbFZABcdryreWet9Ea4LvTJcGsqrMzxHx98MMrotbir7yrKCEXw7nadnHM8Dq38EGfSh6dqA9QWTyefMLEcBYJUuekgW4BYPJcr9E7j"

        let key13: HDKey = "tprv8ZgxMBicQKsPeQXeTomURYYS8ZhysPog3wXLPwStJ9LeiPeGvypYe4y6HhWadxZi4BB2dLSAMXVkoRi8AoeNXmjETeYFiyRi56BhFnkm9uh"
        let key14: HDKey = "tprv8ceMhknangxznNWYWLbRe6ovqv4rPkrnv61XEwfaoaXwHtPQVT8Rg4PUQaGuuHCEyRC4bAthkWKmmKGML38nCcn7sEZ4v1Cw5Ar6TP63QcC"

        XCTAssert(try! key1 |> deriveHDPrivateKey("0'") == key2)
        XCTAssert(try! key2 |> deriveHDPrivateKey("1") == key3)
        XCTAssert(try! key3 |> deriveHDPrivateKey("2'") == key4)
        XCTAssert(try! key4 |> deriveHDPrivateKey("2") == key5)
        XCTAssert(try! key5 |> deriveHDPrivateKey("1000000000") == key6)

        XCTAssert(try! key7 |> deriveHDPrivateKey("0") == key8)
        XCTAssert(try! key8 |> deriveHDPrivateKey("2147483647'") == key9)
        XCTAssert(try! key9 |> deriveHDPrivateKey("1") == key10)
        XCTAssert(try! key10 |> deriveHDPrivateKey("2147483646'") == key11)
        XCTAssert(try! key11 |> deriveHDPrivateKey("2") == key12)

        XCTAssert(try! key13 |> deriveHDPrivateKey("1") == key14)

        XCTAssertThrowsError(try "foobar" |> deriveHDPrivateKey("1") == key14) // Bad parent key
    }

    func testDeriveHDPublicKeyFromPublic() {
        // Public derivation

        // public m/0h (fail)
        XCTAssertThrowsError(try "xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8" |> deriveHDPublicKey("0'") == "won't happen")

        // public m/0h/1
        XCTAssert(try! "xpub68Gmy5EdvgibQVfPdqkBBCHxA5htiqg55crXYuXoQRKfDBFA1WEjWgP6LHhwBZeNK1VTsfTFUHCdrfp1bgwQ9xv5ski8PX9rL2dZXvgGDnw" |> deriveHDPublicKey("1") == "xpub6ASuArnXKPbfEwhqN6e3mwBcDTgzisQN1wXN9BJcM47sSikHjJf3UFHKkNAWbWMiGj7Wf5uMash7SyYq527Hqck2AxYysAA7xmALppuCkwQ")

        // public m/0h/1/2h (fail)
        XCTAssertThrowsError(try "xpub6ASuArnXKPbfEwhqN6e3mwBcDTgzisQN1wXN9BJcM47sSikHjJf3UFHKkNAWbWMiGj7Wf5uMash7SyYq527Hqck2AxYysAA7xmALppuCkwQ" |> deriveHDPublicKey("2'") == "won't happen")

        // public m/0h/1/2h/2
        XCTAssert(try! "xpub6D4BDPcP2GT577Vvch3R8wDkScZWzQzMMUm3PWbmWvVJrZwQY4VUNgqFJPMM3No2dFDFGTsxxpG5uJh7n7epu4trkrX7x7DogT5Uv6fcLW5" |> deriveHDPublicKey("2") == "xpub6FHa3pjLCk84BayeJxFW2SP4XRrFd1JYnxeLeU8EqN3vDfZmbqBqaGJAyiLjTAwm6ZLRQUMv1ZACTj37sR62cfN7fe5JnJ7dh8zL4fiyLHV")

        // public m/0h/1/2h/2/1000000000
        XCTAssert(try! "xpub6FHa3pjLCk84BayeJxFW2SP4XRrFd1JYnxeLeU8EqN3vDfZmbqBqaGJAyiLjTAwm6ZLRQUMv1ZACTj37sR62cfN7fe5JnJ7dh8zL4fiyLHV" |> deriveHDPublicKey("1000000000") == "xpub6H1LXWLaKsWFhvm6RVpEL9P4KfRZSW7abD2ttkWP3SSQvnyA8FSVqNTEcYFgJS2UaFcxupHiYkro49S8yGasTvXEYBVPamhGW6cFJodrTHy")
    }

    func testDeriveHDPublicKeyFromPrivate() {
        // Private derivation

        // private m/0h
        XCTAssert(try! "xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi" |> deriveHDPublicKey("0'") == "xpub68Gmy5EdvgibQVfPdqkBBCHxA5htiqg55crXYuXoQRKfDBFA1WEjWgP6LHhwBZeNK1VTsfTFUHCdrfp1bgwQ9xv5ski8PX9rL2dZXvgGDnw")

        // private m/0h/1
        XCTAssert(try! "xprv9uHRZZhk6KAJC1avXpDAp4MDc3sQKNxDiPvvkX8Br5ngLNv1TxvUxt4cV1rGL5hj6KCesnDYUhd7oWgT11eZG7XnxHrnYeSvkzY7d2bhkJ7" |> deriveHDPublicKey("1") == "xpub6ASuArnXKPbfEwhqN6e3mwBcDTgzisQN1wXN9BJcM47sSikHjJf3UFHKkNAWbWMiGj7Wf5uMash7SyYq527Hqck2AxYysAA7xmALppuCkwQ")

        // private m/0h/1/2h
        XCTAssert(try! "xprv9wTYmMFdV23N2TdNG573QoEsfRrWKQgWeibmLntzniatZvR9BmLnvSxqu53Kw1UmYPxLgboyZQaXwTCg8MSY3H2EU4pWcQDnRnrVA1xe8fs" |> deriveHDPublicKey("2'") == "xpub6D4BDPcP2GT577Vvch3R8wDkScZWzQzMMUm3PWbmWvVJrZwQY4VUNgqFJPMM3No2dFDFGTsxxpG5uJh7n7epu4trkrX7x7DogT5Uv6fcLW5")

        // private m/0h/1/2h/2
        XCTAssert(try! "xprv9z4pot5VBttmtdRTWfWQmoH1taj2axGVzFqSb8C9xaxKymcFzXBDptWmT7FwuEzG3ryjH4ktypQSAewRiNMjANTtpgP4mLTj34bhnZX7UiM" |> deriveHDPublicKey("2") == "xpub6FHa3pjLCk84BayeJxFW2SP4XRrFd1JYnxeLeU8EqN3vDfZmbqBqaGJAyiLjTAwm6ZLRQUMv1ZACTj37sR62cfN7fe5JnJ7dh8zL4fiyLHV")

        // private m/0h/1/2h/2/1000000000
        XCTAssert(try! "xprvA2JDeKCSNNZky6uBCviVfJSKyQ1mDYahRjijr5idH2WwLsEd4Hsb2Tyh8RfQMuPh7f7RtyzTtdrbdqqsunu5Mm3wDvUAKRHSC34sJ7in334" |> deriveHDPublicKey("1000000000") == "xpub6H1LXWLaKsWFhvm6RVpEL9P4KfRZSW7abD2ttkWP3SSQvnyA8FSVqNTEcYFgJS2UaFcxupHiYkro49S8yGasTvXEYBVPamhGW6cFJodrTHy")
    }

    // github.com/bitcoin/bips/blob/master/bip-0032.mediawiki#test-vector-2

    func testDeriveHDPublicKeyFromPublic2() {
        // Public derivation

        // public m/0
        XCTAssert(try! "xpub661MyMwAqRbcFW31YEwpkMuc5THy2PSt5bDMsktWQcFF8syAmRUapSCGu8ED9W6oDMSgv6Zz8idoc4a6mr8BDzTJY47LJhkJ8UB7WEGuduB" |> deriveHDPublicKey("0") == "xpub69H7F5d8KSRgmmdJg2KhpAK8SR3DjMwAdkxj3ZuxV27CprR9LgpeyGmXUbC6wb7ERfvrnKZjXoUmmDznezpbZb7ap6r1D3tgFxHmwMkQTPH")

        // public m/0/2147483647h (fail)
        XCTAssertThrowsError(try "xpub69H7F5d8KSRgmmdJg2KhpAK8SR3DjMwAdkxj3ZuxV27CprR9LgpeyGmXUbC6wb7ERfvrnKZjXoUmmDznezpbZb7ap6r1D3tgFxHmwMkQTPH" |> deriveHDPublicKey("2147483647'") == "won't happen")

        // public m/0/2147483647h/1
        XCTAssert(try! "xpub6ASAVgeehLbnwdqV6UKMHVzgqAG8Gr6riv3Fxxpj8ksbH9ebxaEyBLZ85ySDhKiLDBrQSARLq1uNRts8RuJiHjaDMBU4Zn9h8LZNnBC5y4a" |> deriveHDPublicKey("1") == "xpub6DF8uhdarytz3FWdA8TvFSvvAh8dP3283MY7p2V4SeE2wyWmG5mg5EwVvmdMVCQcoNJxGoWaU9DCWh89LojfZ537wTfunKau47EL2dhHKon")

        // public m/0/2147483647h/12147483646h (fail)
        XCTAssertThrowsError(try "xpub6DF8uhdarytz3FWdA8TvFSvvAh8dP3283MY7p2V4SeE2wyWmG5mg5EwVvmdMVCQcoNJxGoWaU9DCWh89LojfZ537wTfunKau47EL2dhHKon" |> deriveHDPublicKey("2147483646'") == "won't happen")

        // public m/0/2147483647h/1/2147483646h/2
        XCTAssert(try! "xpub6ERApfZwUNrhLCkDtcHTcxd75RbzS1ed54G1LkBUHQVHQKqhMkhgbmJbZRkrgZw4koxb5JaHWkY4ALHY2grBGRjaDMzQLcgJvLJuZZvRcEL" |> deriveHDPublicKey("2") == "xpub6FnCn6nSzZAw5Tw7cgR9bi15UV96gLZhjDstkXXxvCLsUXBGXPdSnLFbdpq8p9HmGsApME5hQTZ3emM2rnY5agb9rXpVGyy3bdW6EEgAtqt")
    }

    func testDeriveHDPublicKeyFromPrivate2() {
        // Private derivation

        // private m/0
        XCTAssert(try! "xprv9s21ZrQH143K31xYSDQpPDxsXRTUcvj2iNHm5NUtrGiGG5e2DtALGdso3pGz6ssrdK4PFmM8NSpSBHNqPqm55Qn3LqFtT2emdEXVYsCzC2U" |> deriveHDPublicKey("0") == "xpub69H7F5d8KSRgmmdJg2KhpAK8SR3DjMwAdkxj3ZuxV27CprR9LgpeyGmXUbC6wb7ERfvrnKZjXoUmmDznezpbZb7ap6r1D3tgFxHmwMkQTPH")

        // private m/0/2147483647h
        XCTAssert(try! "xprv9vHkqa6EV4sPZHYqZznhT2NPtPCjKuDKGY38FBWLvgaDx45zo9WQRUT3dKYnjwih2yJD9mkrocEZXo1ex8G81dwSM1fwqWpWkeS3v86pgKt" |> deriveHDPublicKey("2147483647'") == "xpub6ASAVgeehLbnwdqV6UKMHVzgqAG8Gr6riv3Fxxpj8ksbH9ebxaEyBLZ85ySDhKiLDBrQSARLq1uNRts8RuJiHjaDMBU4Zn9h8LZNnBC5y4a")

        // private m/0/2147483647h/1
        XCTAssert(try! "xprv9wSp6B7kry3Vj9m1zSnLvN3xH8RdsPP1Mh7fAaR7aRLcQMKTR2vidYEeEg2mUCTAwCd6vnxVrcjfy2kRgVsFawNzmjuHc2YmYRmagcEPdU9" |> deriveHDPublicKey("1") == "xpub6DF8uhdarytz3FWdA8TvFSvvAh8dP3283MY7p2V4SeE2wyWmG5mg5EwVvmdMVCQcoNJxGoWaU9DCWh89LojfZ537wTfunKau47EL2dhHKon")

        // private m/0/2147483647h/1/2147483646h
        XCTAssert(try! "xprv9zFnWC6h2cLgpmSA46vutJzBcfJ8yaJGg8cX1e5StJh45BBciYTRXSd25UEPVuesF9yog62tGAQtHjXajPPdbRCHuWS6T8XA2ECKADdw4Ef" |> deriveHDPublicKey("2147483646'") == "xpub6ERApfZwUNrhLCkDtcHTcxd75RbzS1ed54G1LkBUHQVHQKqhMkhgbmJbZRkrgZw4koxb5JaHWkY4ALHY2grBGRjaDMzQLcgJvLJuZZvRcEL")

        // private m/0/2147483647h/1/2147483646h/2
        XCTAssert(try! "xprvA1RpRA33e1JQ7ifknakTFpgNXPmW2YvmhqLQYMmrj4xJXXWYpDPS3xz7iAxn8L39njGVyuoseXzU6rcxFLJ8HFsTjSyQbLYnMpCqE2VbFWc" |> deriveHDPublicKey("2") == "xpub6FnCn6nSzZAw5Tw7cgR9bi15UV96gLZhjDstkXXxvCLsUXBGXPdSnLFbdpq8p9HmGsApME5hQTZ3emM2rnY5agb9rXpVGyy3bdW6EEgAtqt")
    }

    func testDeriveHDPublicKeyTestnet() {
        XCTAssert(try! "tprv8ZgxMBicQKsPeQXeTomURYYS8ZhysPog3wXLPwStJ9LeiPeGvypYe4y6HhWadxZi4BB2dLSAMXVkoRi8AoeNXmjETeYFiyRi56BhFnkm9uh" |> deriveHDPublicKey("1") == "tpubD9LPrAppw4effqYLPzG23WU3QwanZ63hVPcJXThtDrLL8NeB7qx1rZ1Lage8GLtHHjiJMNFhMS1pL6xBiM2MwpmBpZbDLXZxfUFEg9Fvh4t")

        XCTAssert(try! "tpubD9LPrAppw4effqYLPzG23WU3QwanZ63hVPcJXThtDrLL8NeB7qx1rZ1Lage8GLtHHjiJMNFhMS1pL6xBiM2MwpmBpZbDLXZxfUFEg9Fvh4t" |> deriveHDPublicKey("1") == "tpubDBUXE2QrFFQBfPLxoKD3U1zG294LmLSG3rD9MvREmKcExYBeH4U1gyHcrtZDZe6JFxMFYVzYYhRDWCuJAQE3AbdpD3Qz4FdPVu5UHLT1NKa")
    }

    func testToHDPublicKey() {
        XCTAssert(try! "xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi" |> toHDPublicKey == "xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8")

        XCTAssert(try! "xprv9s21ZrQH143K31xYSDQpPDxsXRTUcvj2iNHm5NUtrGiGG5e2DtALGdso3pGz6ssrdK4PFmM8NSpSBHNqPqm55Qn3LqFtT2emdEXVYsCzC2U" |> toHDPublicKey == "xpub661MyMwAqRbcFW31YEwpkMuc5THy2PSt5bDMsktWQcFF8syAmRUapSCGu8ED9W6oDMSgv6Zz8idoc4a6mr8BDzTJY47LJhkJ8UB7WEGuduB")

        XCTAssert(try! "tprv8ZgxMBicQKsPeQXeTomURYYS8ZhysPog3wXLPwStJ9LeiPeGvypYe4y6HhWadxZi4BB2dLSAMXVkoRi8AoeNXmjETeYFiyRi56BhFnkm9uh" |> toHDPublicKey == "tpubD6NzVbkrYhZ4XsZSMTS4pxCYhbDv2izadF87gTVBiR93Ysu3ZNe8pZaxTout4ifQXCUfp2wAChtcHNrbVka3KzfXNRM7gv9pwM57SB7AMFx")
    }

    func testToECKey() {
        XCTAssert(try! "xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi" |> toECKey |> rawValue |> toBase16 == "e8f32e723decf4051aefac8e2c93c9c5b214313817cdb01a1494b917c8436b35")

        XCTAssert(try! "xpub661MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8" |> toECKey |> rawValue |> toBase16 == "0339a36013301597daef41fbe593a02cc513d0b55527ec2df1050e2e8ff49c85c2")

        XCTAssert(try! "tprv8ZgxMBicQKsPeQXeTomURYYS8ZhysPog3wXLPwStJ9LeiPeGvypYe4y6HhWadxZi4BB2dLSAMXVkoRi8AoeNXmjETeYFiyRi56BhFnkm9uh" |> toECKey |> rawValue |> toBase16 == "8ed1d17dabce1fccbbe5e9bf008b318334e5bcc78eb9e7c1ea850b7eb0ddb9c8")

        XCTAssert(try! "tpubD9LPrAppw4effqYLPzG23WU3QwanZ63hVPcJXThtDrLL8NeB7qx1rZ1Lage8GLtHHjiJMNFhMS1pL6xBiM2MwpmBpZbDLXZxfUFEg9Fvh4t" |> toECKey |> rawValue |> toBase16 == "029220af53b11605932e6101c962bdc752a234c6b0c2f0c398844e47b75503a692")
    }

    func testAccessors() {
        XCTAssertEqual("xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi" |> tagHDKey |> prefix, "xprv")
        XCTAssertEqual(try! "xprv9s21ZrQH143K3QTDL4LXw2F7HEK3wJUD2nW2nRk4stbPy6cq3jPPqjiChkVvvNKmPGJxWUtg6LnF5kejMRNNU3TGtRBeJgk33yuGBxrMPHi" |> tagHDKey |> network, .mainnet)
        XCTAssertEqual(try! "tprv8ZgxMBicQKsPeQXeTomURYYS8ZhysPog3wXLPwStJ9LeiPeGvypYe4y6HhWadxZi4BB2dLSAMXVkoRi8AoeNXmjETeYFiyRi56BhFnkm9uh" |> tagHDKey |> network, .testnet)
        XCTAssertTrue("tprv8ZgxMBicQKsPeQXeTomURYYS8ZhysPog3wXLPwStJ9LeiPeGvypYe4y6HhWadxZi4BB2dLSAMXVkoRi8AoeNXmjETeYFiyRi56BhFnkm9uh" |> tagHDKey |> isPrivate)
        XCTAssertTrue("tpubD9LPrAppw4effqYLPzG23WU3QwanZ63hVPcJXThtDrLL8NeB7qx1rZ1Lage8GLtHHjiJMNFhMS1pL6xBiM2MwpmBpZbDLXZxfUFEg9Fvh4t" |> tagHDKey |> isPublic)
    }

    func testKeyDerivation() {
        // Cold wallet generates these
        let network = Network.mainnet
        let entropy = Bitcoin.seed(bits: 256)
        let mnemonic = try! entropy |> newMnemonic
        let seed = try! mnemonic |> toSeed
        let version = HDKeyVersion.findVersion(coinType: .btc, network: network, encoding: .p2pkh)!
        let masterPrivateKey = try! seed |> newHDPrivateKey(hdKeyVersion: version)

        let accountPrivateKey = try! masterPrivateKey |> deriveHDAccountPrivateKey(accountIndex: 0)
        let accountPublicKey = try! accountPrivateKey |> toHDPublicKey

        // Hot wallet receives only accountPublicKey from cold wallet,
        // from which it can generate any number of public keys/payment addresses.
        for i in 0 ..< 10 {
            let addressPublicKey = try! accountPublicKey |> deriveHDAddressPublicKey(chainType: .external, addressIndex: i)
            let ecPublicKey = try! (addressPublicKey |> toECKey) as! ECCompressedPublicKey
            let paymentAddress =  try! ecPublicKey |> toECPaymentAddress(network: network, type: .p2kh)
            print(paymentAddress)
        }
    }

    func testBIP49Derivation() {
        // Test vectors from https://github.com/bitcoin/bips/blob/master/bip-0049.mediawiki
        let masterSeedWords: Mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
        let version = HDKeyVersion.findVersion(coinType: .btc, network: .testnet, encoding: .p2pkh)!
        let masterSeed = try! masterSeedWords |> toSeed |> newHDPrivateKey(hdKeyVersion: version)
        XCTAssertEqual(masterSeed, "tprv8ZgxMBicQKsPe5YMU9gHen4Ez3ApihUfykaqUorj9t6FDqy3nP6eoXiAo2ssvpAjoLroQxHqr3R5nE3a5dU3DHTjTgJDd7zrbniJr6nrCzd" |> tagHDKey)

        // Account 0, root = m/49'/1'/0'
        let account0Xpriv = try! masterSeed |> deriveHDAccountPrivateKey(purpose: .p2wpkhInP2sh, accountIndex: 0)
        XCTAssertEqual(account0Xpriv, "tprv8gRrNu65W2Msef2BdBSUgFdRTGzC8EwVXnV7UGS3faeXtuMVtGfEdidVeGbThs4ELEoayCAzZQ4uUji9DUiAs7erdVskqju7hrBcDvDsdbY" |> tagHDKey)

        // Account 0, first receiving private key = m/49'/1'/0'/0/0
        let account0recvPrivateHDKey = try! account0Xpriv |> deriveHDAddressPrivateKey(chainType: .external, addressIndex: 0)
        let account0recvPrivateECKey = try! account0recvPrivateHDKey |> toECPrivateKey
        XCTAssertEqual(account0recvPrivateECKey®, "c9bdb49cfbaedca21c4b1f3a7803c34636b1d7dc55a717132443fc3f4c5867e8" |> dataLiteral)
        let account0recvPublicECKey = try! account0recvPrivateHDKey |> toECPublicKey
        XCTAssertEqual(account0recvPublicECKey®, "03a1af804ac108a8a51782198c2d034b28bf90c8803f5a53f76276fa69a4eae77f" |> dataLiteral)

        // Address derivation
        let keyhash = account0recvPublicECKey® |> toBitcoin160
        XCTAssertEqual(keyhash®, "38971f73930f6c141d977ac4fd4a727c854935b3" |> dataLiteral)
        let scriptSigOps = [ScriptOperation(.pushSize0), try! ScriptOperation(keyhash®)]
        let scriptSig = Script(scriptSigOps)
        let scriptSigData = scriptSig |> serialize
        XCTAssertEqual(scriptSigData, "001438971f73930f6c141d977ac4fd4a727c854935b3" |> dataLiteral)
        let scriptSigHash = scriptSigData |> toBitcoin160
        XCTAssertEqual(scriptSigHash®, "336caa13e08b96080a32b5d818d59b4ab3b36742" |> dataLiteral)
        let paymentAddress = scriptSigHash |> addressEncode(network: .testnet, type: .p2sh)
        XCTAssertEqual(paymentAddress, "2Mww8dCYPUpKHofjgcXcBCEGmniw9CoaiD2" |> tagPaymentAddress)
    }

    func testTrezorDerivation() {
        let masterSeedWords: Mnemonic = "lens office sadness soul chuckle survey drama busy thing step say glove"
        let passphrase = ""
        let version = HDKeyVersion.findVersion(coinType: .btc, network: .mainnet, encoding: .p2wpkhInP2sh)!
        let masterSeed = try! masterSeedWords |> toSeed(passphrase: passphrase) |> newHDPrivateKey(hdKeyVersion: version)

        // Account 0, root = m/49'/0'/0'
        let account0Xpriv = try! masterSeed |> deriveHDAccountPrivateKey(accountIndex: 0)
        let account0Xpub = try! account0Xpriv |> toHDPublicKey
        XCTAssertEqual(account0Xpub, "ypub6X4r72NFyaXdVtDbsNxiqLX6WcNjJSkqcyDNybm3qxtf4xPEQw3txbpVUxGDYt84BKnRCFu2BYC12n3kgkDqxsbpuxSAMkGbQZhxktboHT8" |> tagHDKey)
    }
}
