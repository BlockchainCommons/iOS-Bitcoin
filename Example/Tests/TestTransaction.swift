//
//  TestTransaction.swift
//  Bitcoin_Tests
//
//  Created by Wolf McNally on 11/7/18.
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

class TestTransaction: XCTestCase {
    func testTransactionDecode() {
        let f = fromHex >>> transactionDecode

        let tx1 = "0100000001b3807042c92f449bbf79b33ca59d7dfec7f4cc71096704a9c526dddf496ee0970000000000ffffffff01c8af0000000000001976a91458b7a60f11a904feef35a639b6048de8dd4d9f1c88ac00000000"
        let tx1Decoded = """
            {"transaction":{"hash":"f9be6abf60342de5606421c7deaaf2d3f7133490db5242e8507e05926b16d090","inputs":[{"previous_output":{"hash":"97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b3","index":"0"},"script":"","sequence":"4294967295"}],"lock_time":"0","outputs":[{"address_hash":"58b7a60f11a904feef35a639b6048de8dd4d9f1c","script":"dup hash160 [58b7a60f11a904feef35a639b6048de8dd4d9f1c] equalverify checksig","value":"45000"}],"version":"1"}}

            """
        XCTAssert(try! tx1 |> f == tx1Decoded)

        let tx2 = "0100000001b3807042c92f449bbf79b33ca59d7dfec7f4cc71096704a9c526dddf496ee0970100000000070000000200000000000000003a6a3814576f496f20b0befe21f39f765e81543ebd1790ec4a03d1b5a1c2e912749d90d0fd7b16322749e301a2b0dbfe278509011564590412b2772a000000000000001976a914cc04492c12d0ddeb4cf88cfccb0d6d78d0fcd39d88ac00000000"
        let tx2Decoded = """
            {"transaction":{"hash":"4a013715c2ef8ddeae2792eea4751565acd1ad5ed27542d45f2ebe571f4899e9","inputs":[{"previous_output":{"hash":"97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b3","index":"1"},"script":"","sequence":"7"}],"lock_time":"0","outputs":[{"script":"return [14576f496f20b0befe21f39f765e81543ebd1790ec4a03d1b5a1c2e912749d90d0fd7b16322749e301a2b0dbfe278509011564590412b277]","stealth":{"prefix":"2927803294","ephemeral_public_key":"0214576f496f20b0befe21f39f765e81543ebd1790ec4a03d1b5a1c2e912749d90"},"value":"0"},{"address_hash":"cc04492c12d0ddeb4cf88cfccb0d6d78d0fcd39d","script":"dup hash160 [cc04492c12d0ddeb4cf88cfccb0d6d78d0fcd39d] equalverify checksig","value":"42"}],"version":"1"}}

            """
        XCTAssert(try! tx2 |> f == tx2Decoded)

        let tx3 = "0100000001b3807042c92f449bbf79b33ca59d7dfec7f4cc71096704a9c526dddf496ee09701000000000700000001f4010000000000001976a91418c0bd8d1818f1bf99cb1df2269c645318ef7b7388ac00000000"
        let tx3Decoded = """
            {"transaction":{"hash":"bfe73280b111a7dae1714b1efe869c0d0c854dd9d1c3ba51fa439e7fb4d0e63c","inputs":[{"previous_output":{"hash":"97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b3","index":"1"},"script":"","sequence":"7"}],"lock_time":"0","outputs":[{"address_hash":"18c0bd8d1818f1bf99cb1df2269c645318ef7b73","script":"dup hash160 [18c0bd8d1818f1bf99cb1df2269c645318ef7b73] equalverify checksig","value":"500"}],"version":"1"}}

            """
        XCTAssert(try! tx3 |> f == tx3Decoded)

        let tx4 = "01000000017d01943c40b7f3d8a00a2d62fa1d560bf739a2368c180615b0a7937c0e883e7c000000006b4830450221008f66d188c664a8088893ea4ddd9689024ea5593877753ecc1e9051ed58c15168022037109f0d06e6068b7447966f751de8474641ad2b15ec37f4a9d159b02af68174012103e208f5403383c77d5832a268c9f71480f6e7bfbdfa44904becacfad66163ea31ffffffff01c8af0000000000001976a91458b7a60f11a904feef35a639b6048de8dd4d9f1c88ac00000000"
        let tx4Decoded = """
            {"transaction":{"hash":"37c9c4ee0e84c7c7924f74d92cf0779ec6e8fc4c57ebab2593562d52c61c5eb8","inputs":[{"address_hash":"c564c740c6900b93afc9f1bdaef0a9d466adf6ee","previous_output":{"hash":"7c3e880e7c93a7b01506188c36a239f70b561dfa622d0aa0d8f3b7403c94017d","index":"0"},"script":"[30450221008f66d188c664a8088893ea4ddd9689024ea5593877753ecc1e9051ed58c15168022037109f0d06e6068b7447966f751de8474641ad2b15ec37f4a9d159b02af6817401] [03e208f5403383c77d5832a268c9f71480f6e7bfbdfa44904becacfad66163ea31]","sequence":"4294967295"}],"lock_time":"0","outputs":[{"address_hash":"58b7a60f11a904feef35a639b6048de8dd4d9f1c","script":"dup hash160 [58b7a60f11a904feef35a639b6048de8dd4d9f1c] equalverify checksig","value":"45000"}],"version":"1"}}

            """
        XCTAssert(try! tx4 |> f == tx4Decoded)
    }

    func testInput() {
        XCTAssert(OutputPoint().description == "OutputPoint(hash: 0000000000000000000000000000000000000000000000000000000000000000, index: 0)")

        let hash = try! "97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b3" |> base16Decode |> toHashDigest
        let hash2 = try! "97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b5" |> base16Decode |> toHashDigest
        var outputPoint = OutputPoint(hash: hash, index: 3)
        var outputPoint2 = outputPoint
        outputPoint.hash = hash2
        outputPoint2.index = 5
        XCTAssert(outputPoint.description == "OutputPoint(hash: 97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b5, index: 3)")
        XCTAssert(outputPoint2.description == "OutputPoint(hash: 97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b3, index: 5)")

        XCTAssert(Input().description == "Input(previousOutput: OutputPoint(hash: 0000000000000000000000000000000000000000000000000000000000000000, index: 0), sequence: 0x0)")

        var input = Input(previousOutput: outputPoint)
        var input2 = input
        input.sequence = 42
        input2.previousOutput = outputPoint2
        XCTAssert(input.description == "Input(previousOutput: OutputPoint(hash: 97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b5, index: 3), sequence: 0x2a)")
        XCTAssert(input2.description == "Input(previousOutput: OutputPoint(hash: 97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b3, index: 5), sequence: 0xffffffff)")
    }

    func testOutput() {
        XCTAssert(Output().description == "Output(value: 18446744073709551615, script: '')")
        
        let value = try! "1.0" |> btcToSatoshi
        let value2 = try! "0.5" |> btcToSatoshi

        var output = try! Output(value: value, paymentAddress: "1966U1pjj15tLxPXZ19U48c99EJDkdXeqb")
        XCTAssert(output.description == "Output(value: 100000000, script: 'dup hash160 [58b7a60f11a904feef35a639b6048de8dd4d9f1c] equalverify checksig')")

        var output2 = output
        output2.value = value2
        try! output.setPaymentAddress("1CK6KHY6MHgYvmRQ4PAafKYDrg1ejbH1cE")
        XCTAssert(output.description == "Output(value: 100000000, script: 'dup hash160 [7c154ed1dc59609e3d26abb2df2ea3d587cd8c41] equalverify checksig')")
        XCTAssert(output2.description == "Output(value: 50000000, script: 'dup hash160 [58b7a60f11a904feef35a639b6048de8dd4d9f1c] equalverify checksig')")
    }

    func testTransaction() {
//
//        let transaction = Transaction()
//        transaction.version = 1
//        transaction.lockTime = 42
////        transaction.inputs = [input]
//        transaction.outputs = [output]
//        print(transaction)
    }
}
