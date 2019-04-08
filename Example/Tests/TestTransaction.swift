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
import WolfCore

class TestTransaction: XCTestCase {
    func testTransactionDecode() {
        let f = tagBase16 >>> toData >>> transactionDecode

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
        XCTAssertEqual(OutputPoint().description, """
        {"hash":"0000000000000000000000000000000000000000000000000000000000000000","index":0}
        """)

        let hash = try! "97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b3" |> dataLiteral |> tagHashDigest
        let hash2 = try! "97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b5" |> dataLiteral |> tagHashDigest
        var outputPoint = OutputPoint(hash: hash, index: 3)
        var outputPoint2 = outputPoint
        outputPoint.hash = hash2
        outputPoint2.index = 5
        XCTAssertEqual(outputPoint.description, """
        {"hash":"97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b5","index":3}
        """)
        XCTAssertEqual(outputPoint2.description,"""
        {"hash":"97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b3","index":5}
        """)

        XCTAssertEqual(Input().description, """
        {"previousOutput":{"hash":"0000000000000000000000000000000000000000000000000000000000000000","index":0},"script":"","sequence":0}
        """)

        var input = Input(previousOutput: outputPoint)
        var input2 = input
        input.sequence = 42
        input2.previousOutput = outputPoint2
        XCTAssertEqual(input.description, """
        {"previousOutput":{"hash":"97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b5","index":3},"script":"","sequence":42}
        """)
        XCTAssertEqual(input2.description, """
        {"previousOutput":{"hash":"97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b3","index":5},"script":"","sequence":4294967295}
        """)
    }

    func testOutput() {
        XCTAssertEqual(Output().description, """
        {"script":"","value":18446744073709551615}
        """)

        let value = try! "1.0" |> btcToSatoshi
        let value2 = try! "0.5" |> btcToSatoshi

        var output = try! Output(value: value, paymentAddress: "1966U1pjj15tLxPXZ19U48c99EJDkdXeqb")
        XCTAssertEqual(output.description, """
        {"script":"dup hash160 [58b7a60f11a904feef35a639b6048de8dd4d9f1c] equalverify checksig","value":100000000}
        """)

        var output2 = output
        output2.value = value2
        try! output.setPaymentAddress("1CK6KHY6MHgYvmRQ4PAafKYDrg1ejbH1cE")
        XCTAssertEqual(output.description, """
        {"script":"dup hash160 [7c154ed1dc59609e3d26abb2df2ea3d587cd8c41] equalverify checksig","value":100000000}
        """)
        XCTAssertEqual(output2.description, """
        {"script":"dup hash160 [58b7a60f11a904feef35a639b6048de8dd4d9f1c] equalverify checksig","value":50000000}
        """)
    }

    private func makeInput(hash: String, index: Int, sequence: UInt32? = nil) -> Input {
        let outputPoint = try! OutputPoint(hash: hash |> dataLiteral |> tagHashDigest, index: index)
        return Input(previousOutput: outputPoint, sequence: sequence)
    }

    private func makeOutput(satoshis: Satoshis, paymentAddress: PaymentAddress) -> Output {
        return try! Output(value: satoshis, paymentAddress: paymentAddress)
    }

    private func makeOutput(btc: String, paymentAddress: PaymentAddress) -> Output {
        return try! makeOutput(satoshis: btc |> Base10.init(rawValue:) |> btcToSatoshi, paymentAddress: paymentAddress)
    }

    func testTransaction() {
        XCTAssertEqual(Transaction().description, """
        {"inputs":[],"lockTime":0,"outputs":[],"version":0}
        """)

        let input = makeInput(hash: "97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b3", index: 3, sequence: 42)
        let output = makeOutput(btc: "1.0", paymentAddress: "1CK6KHY6MHgYvmRQ4PAafKYDrg1ejbH1cE")
        let transaction = Transaction(version: 1, lockTime: 100, inputs: [input], outputs: [output])

        var transaction2 = transaction
        transaction2.version = 2
        transaction2.lockTime = 200
        let input2 = makeInput(hash: "fb478fd8f4ffd1224c5720180feabe3644273f81693679777bdd76fd5ae3576c", index: 5, sequence: 55)
        transaction2.inputs.append(input2)
        let output2 = makeOutput(btc: "0.5", paymentAddress: "1NTC39oN6MimCif7kZbgVb29oQFxukKCPY")
        transaction2.outputs.append(output2)

        XCTAssertEqual(transaction.description, """
        {"inputs":[{"previousOutput":{"hash":"97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b3","index":3},"script":"","sequence":42}],"lockTime":100,"outputs":[{"script":"dup hash160 [7c154ed1dc59609e3d26abb2df2ea3d587cd8c41] equalverify checksig","value":100000000}],"version":1}
        """)
        XCTAssertEqual(transaction2.description, """
        {"inputs":[{"previousOutput":{"hash":"97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b3","index":3},"script":"","sequence":42},{"previousOutput":{"hash":"fb478fd8f4ffd1224c5720180feabe3644273f81693679777bdd76fd5ae3576c","index":5},"script":"","sequence":55}],"lockTime":200,"outputs":[{"script":"dup hash160 [7c154ed1dc59609e3d26abb2df2ea3d587cd8c41] equalverify checksig","value":100000000},{"script":"dup hash160 [eb4eab76288feb6fd4a63df6814e151c03a883d7] equalverify checksig","value":50000000}],"version":2}
        """)
    }

//    func testTransactionEncode() {
//        let input = makeInput(hash: "97e06e49dfdd26c5a904670971ccf4c7fe7d9da53cb379bf9b442fc9427080b3", index: 0)
//        let output = makeOutput(satoshis: 45000, paymentAddress: "1966U1pjj15tLxPXZ19U48c99EJDkdXeqb")
//        let transaction = Transaction(version: 1, inputs: [input], outputs: [output])
//        print(transaction |> toData |> toBase16)
//    }

//    func testTransaction1() {
//        UInt32 version = 2345;
//        UInt32 locktime = 4568656;
//        let input = Input();
//    }

    func test_constructor_2__valid_input__returns_input_initialized() {
        let version: UInt32 = 2345;
        let lockTime: UInt32 = 4568656;

        let tx0Inputs = ("f08e44a96bfb5ae63eda1a6620adae37ee37ee4777fb0336e1bbbc4de65310fc" +
        "010000006a473044022050d8368cacf9bf1b8fb1f7cfd9aff63294789eb17601" +
        "39e7ef41f083726dadc4022067796354aba8f2e02363c5e510aa7e2830b11547" +
        "2fb31de67d16972867f13945012103e589480b2f746381fca01a9b12c517b7a4" +
            "82a203c8b2742985da0ac72cc078f2ffffffff") |> dataLiteral
        let tx0LastOutput = "f0c9c467000000001976a914d9d78e26df4e4601cf9b26d09c7b280ee764469f88ac" |> dataLiteral

        let input = try! tx0Inputs |> deserializeInput
        XCTAssertEqual(input.description, """
        {"previousOutput":{"hash":"f08e44a96bfb5ae63eda1a6620adae37ee37ee4777fb0336e1bbbc4de65310fc","index":1},"script":"[3044022050d8368cacf9bf1b8fb1f7cfd9aff63294789eb1760139e7ef41f083726dadc4022067796354aba8f2e02363c5e510aa7e2830b115472fb31de67d16972867f1394501] [03e589480b2f746381fca01a9b12c517b7a482a203c8b2742985da0ac72cc078f2]","sequence":4294967295}
        """)

        let output = try! tx0LastOutput |> deserializeOutput
        XCTAssertEqual(output.description, """
        {"script":"dup hash160 [d9d78e26df4e4601cf9b26d09c7b280ee764469f] equalverify checksig","value":1740950000}
        """)

        let transaction = Transaction(version: version, lockTime: lockTime, inputs: [input], outputs: [output])
        XCTAssertEqual(transaction.description, """
        {"inputs":[{"previousOutput":{"hash":"f08e44a96bfb5ae63eda1a6620adae37ee37ee4777fb0336e1bbbc4de65310fc","index":1},"script":"[3044022050d8368cacf9bf1b8fb1f7cfd9aff63294789eb1760139e7ef41f083726dadc4022067796354aba8f2e02363c5e510aa7e2830b115472fb31de67d16972867f1394501] [03e589480b2f746381fca01a9b12c517b7a482a203c8b2742985da0ac72cc078f2]","sequence":4294967295}],"lockTime":4568656,"outputs":[{"script":"dup hash160 [d9d78e26df4e4601cf9b26d09c7b280ee764469f] equalverify checksig","value":1740950000}],"version":2345}
        """)

        XCTAssert(transaction.isValid)
        XCTAssertEqual(transaction.version, version)
        XCTAssertEqual(transaction.lockTime, lockTime)
        XCTAssertEqual(transaction.inputs, [input])
        XCTAssertEqual(transaction.outputs, [output])
    }

    func test_constructor_4__valid_input__returns_input_initialized() {
        let tx1 = ("0100000001f08e44a96bfb5ae63eda1a6620adae37ee37ee4777fb0336e1bbbc" +
        "4de65310fc010000006a473044022050d8368cacf9bf1b8fb1f7cfd9aff63294" +
        "789eb1760139e7ef41f083726dadc4022067796354aba8f2e02363c5e510aa7e" +
        "2830b115472fb31de67d16972867f13945012103e589480b2f746381fca01a9b" +
        "12c517b7a482a203c8b2742985da0ac72cc078f2ffffffff02f0c9c467000000" +
        "001976a914d9d78e26df4e4601cf9b26d09c7b280ee764469f88ac80c4600f00" +
        "0000001976a9141ee32412020a324b93b1a1acfdfff6ab9ca8fac288ac000000" +
            "00") |> dataLiteral
        let tx = try! tx1 |> deserializeTransaction
        XCTAssertEqual(tx.description, """
        {"inputs":[{"previousOutput":{"hash":"f08e44a96bfb5ae63eda1a6620adae37ee37ee4777fb0336e1bbbc4de65310fc","index":1},"script":"[3044022050d8368cacf9bf1b8fb1f7cfd9aff63294789eb1760139e7ef41f083726dadc4022067796354aba8f2e02363c5e510aa7e2830b115472fb31de67d16972867f1394501] [03e589480b2f746381fca01a9b12c517b7a482a203c8b2742985da0ac72cc078f2]","sequence":4294967295}],"lockTime":0,"outputs":[{"script":"dup hash160 [d9d78e26df4e4601cf9b26d09c7b280ee764469f] equalverify checksig","value":1740950000},{"script":"dup hash160 [1ee32412020a324b93b1a1acfdfff6ab9ca8fac2] equalverify checksig","value":258000000}],"version":1}
        """)
    }

    func test_is_coinbase__empty_inputs__returns_false() {
        let tx = Transaction()
        XCTAssertFalse(tx.isCoinbase)
    }

    func test_is_coinbase__one_null_input__returns_true() {
        var tx = Transaction()
        var input1 = Input()
        input1.previousOutput.index = OutputPoint.nullIndex
        tx.inputs = [input1]
        XCTAssertEqual(tx.description, """
        {"inputs":[{"previousOutput":{"hash":"0000000000000000000000000000000000000000000000000000000000000000","index":4294967295},"script":"","sequence":0}],"lockTime":0,"outputs":[],"version":0}
        """)
        XCTAssert(tx.isCoinbase)

        // is_coinbase__one_non_null_input__returns_false
        var input2 = input1
        input2.previousOutput.index = 42
        tx.inputs = [input2]
        XCTAssertEqual(tx.description, """
        {"inputs":[{"previousOutput":{"hash":"0000000000000000000000000000000000000000000000000000000000000000","index":42},"script":"","sequence":0}],"lockTime":0,"outputs":[],"version":0}
        """)
        XCTAssertFalse(tx.isCoinbase)

        // is_coinbase__two_inputs_first_null__returns_false
        tx.inputs = [input1, input2]
        XCTAssertEqual(tx.description, """
        {"inputs":[{"previousOutput":{"hash":"0000000000000000000000000000000000000000000000000000000000000000","index":4294967295},"script":"","sequence":0},{"previousOutput":{"hash":"0000000000000000000000000000000000000000000000000000000000000000","index":42},"script":"","sequence":0}],"lockTime":0,"outputs":[],"version":0}
        """)
        XCTAssertFalse(tx.isCoinbase)
    }

    func test_is_null_non_coinbase__empty_inputs__returns_false() {
        let tx = Transaction()
        XCTAssertFalse(tx.isNullNonCoinbase)
    }

    func test_is_null_non_coinbase__one_null_input__returns_false() {
        var tx = Transaction()
        var input1 = Input()
        input1.previousOutput.index = OutputPoint.nullIndex
        tx.inputs = [input1]
        XCTAssertFalse(tx.isNullNonCoinbase)
    }

    func test_is_null_non_coinbase__one_non_null_input__returns_false() {
        var tx = Transaction()
        var input1 = Input()
        input1.previousOutput.index = 42
        tx.inputs = [input1]
        XCTAssertFalse(tx.isNullNonCoinbase)
    }

    func test_is_null_non_coinbase__two_inputs_first_null__returns_true() {
        var tx = Transaction()
        var input1 = Input()
        input1.previousOutput.index = OutputPoint.nullIndex
        var input2 = Input()
        input2.previousOutput.index = 42
        tx.inputs = [input1, input2]
        XCTAssert(tx.isNullNonCoinbase)
    }

    func test_is_final__locktime_zero__returns_true() {
        var tx = Transaction()
        tx.lockTime = 0
        XCTAssert(tx.isFinal(blockHeight: 100, blockTime: 100))
    }

    func test_is_final__locktime_less_block_time_greater_threshold__returns_true() {
        var tx = Transaction()
        tx.lockTime = UInt32(locktimeThreshold + 50)
        XCTAssert(tx.isFinal(blockHeight: locktimeThreshold + 100, blockTime: 100))
    }

    func test_is_final__locktime_less_block_height_less_threshold_returns_true() {
        var tx = Transaction()
        tx.lockTime = 50
        XCTAssert(tx.isFinal(blockHeight: 100, blockTime: 100))
    }

    func test_is_final__locktime_input_not_final__returns_false() {
        var input = Input()
        input.sequence = 1
        let tx = Transaction(version: 0, lockTime: 101, inputs: [input], outputs: [])
        XCTAssertFalse(tx.isFinal(blockHeight: 100, blockTime: 100))
    }

    func test_is_final__locktime_inputs_final__returns_true() {
        var input = Input()
        input.sequence = maxInputSequence
        let tx = Transaction(version: 0, lockTime: 101, inputs: [input], outputs: [])
        XCTAssert(tx.isFinal(blockHeight: 100, blockTime: 100))
    }

    func test_is_locked__version_1_empty__returns_false() {
        var tx = Transaction()
        tx.version = 1
        XCTAssertFalse(tx.isLocked(blockHeight: 0, medianTimePast: 0))
    }

    func test_is_locked__version_2_empty__returns_false() {
        var tx = Transaction()
        tx.version = 2
        XCTAssertFalse(tx.isLocked(blockHeight: 0, medianTimePast: 0))
    }

    func test_is_locked__version_1_one_of_two_locked_locked__returns_false() {
        var tx = Transaction()
        tx.inputs = [Input(sequence: 1), Input(sequence: 0)]
        tx.version = 1
        XCTAssertFalse(tx.isLocked(blockHeight: 0, medianTimePast: 0))
    }

    func test_is_locked__version_4_one_of_two_locked__returns_true() {
        let tx = Transaction(version: 4, inputs: [Input(sequence: 1), Input(sequence: 0)])
        XCTAssertTrue(tx.isLocked(blockHeight: 0, medianTimePast: 0))
    }

    func test_is_locktime_conflict__locktime_zero__returns_false() {
        let tx = Transaction(lockTime: 0)
        XCTAssertFalse(tx.isLockTimeConflict)
    }

    func test_is_locktime_conflict__input_sequence_not_maximum__returns_false() {
        let tx = Transaction(lockTime: 2143, inputs: [Input(sequence: 1)])
        XCTAssertFalse(tx.isLockTimeConflict)
    }

    func test_is_locktime_conflict__no_inputs__returns_true() {
        let tx = Transaction(lockTime: 2143)
        XCTAssert(tx.isLockTimeConflict)
    }

    func test_is_locktime_conflict__input_max_sequence__returns_true() {
        let tx = Transaction(lockTime: 2143, inputs: [Input(sequence: maxInputSequence)])
        XCTAssert(tx.isLockTimeConflict)
    }

    func test_from_data__insufficient_version_bytes__failure() {
        let data = Data(bytes: [2])
        XCTAssertThrowsError(try data |> deserializeTransaction)
    }

    func test_from_data__insufficient_input_bytes__failure() {
        let data = "0000000103" |> dataLiteral
        XCTAssertThrowsError(try data |> deserializeTransaction)
    }

    func test_from_data__insufficient_output_bytes__failure() {
        let data = "000000010003" |> dataLiteral
        XCTAssertThrowsError(try data |> deserializeTransaction)
    }

    lazy var TX1_RAW =
    ("0100000001f08e44a96bfb5ae63eda1a6620adae37ee37ee4777fb0336e1bbbc" +
    "4de65310fc010000006a473044022050d8368cacf9bf1b8fb1f7cfd9aff63294" +
    "789eb1760139e7ef41f083726dadc4022067796354aba8f2e02363c5e510aa7e" +
    "2830b115472fb31de67d16972867f13945012103e589480b2f746381fca01a9b" +
    "12c517b7a482a203c8b2742985da0ac72cc078f2ffffffff02f0c9c467000000" +
    "001976a914d9d78e26df4e4601cf9b26d09c7b280ee764469f88ac80c4600f00" +
    "0000001976a9141ee32412020a324b93b1a1acfdfff6ab9ca8fac288ac000000" +
        "00") |> dataLiteral

    lazy var TX1 = try! TX1_RAW |> deserializeTransaction

    lazy var TX1_HASH = try!
    "bf7c3f5a69a78edd81f3eff7e93a37fb2d7da394d48db4d85e7e5353b9b8e270" |> hashDecode

    func test_factory_data_1__case_1__success() {
        XCTAssertTrue(TX1.isValid)
        XCTAssertEqual(TX1.serializedSize, 225)
        XCTAssertEqual(TX1.hash, TX1_HASH)
        XCTAssertEqual(TX1.serializedSize, TX1_RAW.count)
        XCTAssertEqual(TX1 |> serialize, TX1_RAW)
    }

    lazy var TX4_RAW =
    ("010000000364e62ad837f29617bafeae951776e7a6b3019b2da37827921548d1" +
    "a5efcf9e5c010000006b48304502204df0dc9b7f61fbb2e4c8b0e09f3426d625" +
    "a0191e56c48c338df3214555180eaf022100f21ac1f632201154f3c69e1eadb5" +
    "9901a34c40f1127e96adc31fac6ae6b11fb4012103893d5a06201d5cf61400e9" +
    "6fa4a7514fc12ab45166ace618d68b8066c9c585f9ffffffff54b755c39207d4" +
    "43fd96a8d12c94446a1c6f66e39c95e894c23418d7501f681b010000006b4830" +
    "4502203267910f55f2297360198fff57a3631be850965344370f732950b47795" +
    "737875022100f7da90b82d24e6e957264b17d3e5042bab8946ee5fc676d15d91" +
    "5da450151d36012103893d5a06201d5cf61400e96fa4a7514fc12ab45166ace6" +
    "18d68b8066c9c585f9ffffffff0aa14d394a1f0eaf0c4496537f8ab9246d9663" +
    "e26acb5f308fccc734b748cc9c010000006c493046022100d64ace8ec2d5feeb" +
    "3e868e82b894202db8cb683c414d806b343d02b7ac679de7022100a2dcd39940" +
    "dd28d4e22cce417a0829c1b516c471a3d64d11f2c5d754108bdc0b012103893d" +
    "5a06201d5cf61400e96fa4a7514fc12ab45166ace618d68b8066c9c585f9ffff" +
    "ffff02c0e1e400000000001976a914884c09d7e1f6420976c40e040c30b2b622" +
    "10c3d488ac20300500000000001976a914905f933de850988603aafeeb2fd7fc" +
        "e61e66fe5d88ac00000000") |> dataLiteral

    lazy var TX4 = try! TX4_RAW |> deserializeTransaction

    lazy var TX4_HASH = try! "8a6d9302fbe24f0ec756a94ecfc837eaffe16c43d1e68c62dfe980d99eea556f" |> hashDecode

    func test_factory_data_1__case_2__success() {
        XCTAssertEqual(TX4_RAW.count, 523)
        XCTAssertTrue(TX4.isValid)
        XCTAssertEqual(TX4.hash, TX4_HASH)
        XCTAssertEqual(TX4.serializedSize, TX4_RAW.count)
        XCTAssertEqual(TX4 |> serialize, TX4_RAW)
    }

    lazy var TX5_RAW =
    ("01000000023562c207a2a505820324aa03b769ee9c04a221eff59fdab6d52c312544a" +
    "c4b21020000006a473044022075d3dd4cd26137f50d1b8c18b5ecbd13b7309b801f62" +
    "83ebb951b137972d6e5b02206776f5e3acb2d996a9553f2438a4d2566c1fd786d9075" +
    "5a5bca023bd9ae3945b0121029caef1b63490b7deabc9547e3e5d8b13c004b4bfd04d" +
    "fae270874d569e5b89a8ffffffff8593568e460593c3dd30a470977a14928be6a29c6" +
    "14a644c531471a773a63601020000006a47304402201fd9ea7dc62628ea82ff7b38cc" +
    "90b3f2aa8c9ae25aa575600de38c79eafc925602202ca57bcd29d38a3e6aebd6809f7" +
    "be4379d86f173b2ad2d42892dcb1dccca14b60121029caef1b63490b7deabc9547e3e" +
    "5d8b13c004b4bfd04dfae270874d569e5b89a8ffffffff01763d0300000000001976a" +
        "914e0d40d609d0282cc97314e454d194f65c16c257888ac00000000") |> dataLiteral

    lazy var TX5 = try! TX5_RAW |> deserializeTransaction

    func test_is_oversized_coinbase__non_coinbase_tx__returns_false() {
        XCTAssertFalse(TX5.isCoinbase)
        XCTAssertFalse(TX5.isOversizedCoinbase)
    }

    func test_is_oversized_coinbase__script_size_below_min__returns_true() {
        var tx = Transaction()
        var input = Input()
        input.previousOutput.hash = nullHashDigest
        input.previousOutput.index = OutputPoint.nullIndex
        tx.inputs.append(input)
        XCTAssertTrue(tx.isCoinbase)
        XCTAssertTrue(tx.inputs.last!.script.serializedSize(prefix: false) < minCoinbaseSize)
        XCTAssertTrue(tx.isOversizedCoinbase)
    }

    lazy var TX6_RAW =
    ("010000000100000000000000000000000000000000000000000000000000000000000" +
    "00000ffffffff23039992060481e1e157082800def50009dfdc102f42697446757279" +
    "2f5345475749542f00000000015b382d4b000000001976a9148cf4f6175b2651dcdff" +
        "0051970a917ea10189c2d88ac00000000") |> dataLiteral

    lazy var TX6 = try! TX6_RAW |> deserializeTransaction

    func test_is_null_non_coinbase__coinbase_tx__returns_false() {
        XCTAssertFalse(TX6.isNullNonCoinbase)
    }

    func test_is_null_non_coinbase__no_null_input_prevout__returns_false() {
        let tx = Transaction()
        XCTAssertFalse(tx.isCoinbase)
        XCTAssertFalse(tx.isNullNonCoinbase)
    }

    func test_is_null_non_coinbase__null_input_prevout__returns_true() {
        var tx = Transaction()
        tx.inputs.append(Input())
        tx.inputs.append(Input(previousOutput: OutputPoint(hash: nullHashDigest, index: OutputPoint.nullIndex)))
        XCTAssertFalse(tx.isCoinbase)
        XCTAssertTrue(tx.inputs.last!.previousOutput.isNull)
        XCTAssertTrue(tx.isNullNonCoinbase)
    }

    func test_total_input_value__no_cache__returns_zero() {
        var tx = Transaction()
        tx.inputs.append(Input())
        tx.inputs.append(Input())
        XCTAssertEqual(tx.totalInputValue, 0)
    }

    func test_total_output_value__empty_outputs__returns_zero() {
        let tx = Transaction()
        XCTAssertEqual(tx.totalOutputValue, 0)
    }

    func test_total_output_value__non_empty_outputs__returns_sum() {
        let tx = Transaction(outputs: [Output(value: 1200), Output(value: 34)])
        XCTAssertEqual(tx.totalOutputValue, 1234)
    }

    func test_is_overspent__output_does_not_exceed_input__returns_false() {
        let tx = Transaction()
        XCTAssertFalse(tx.isOverspent)
    }

    func test_is_overspent__output_exceeds_input__returns_true() {
        let tx = Transaction(outputs: [Output(value: 1200), Output(value: 34)])
        XCTAssertTrue(tx.isOverspent)
    }

    func test_signature_operations_single_input_output_uninitialized__returns_zero() {
        let tx = Transaction(inputs: [Input()], outputs: [Output()])
        XCTAssertEqual(tx.signatureOperationsCount(bip16: false, bip141: false), 0)
    }

    func test_is_missing_previous_outputs__empty_inputs__returns_false() {
        let tx = Transaction()
        XCTAssertFalse(tx.isMissingPreviousOutputs)
    }

    func test_is_missing_previous_outputs__inputs_without_cache_value__returns_true() {
        let tx = Transaction(inputs: [Input()])
        XCTAssertTrue(tx.isMissingPreviousOutputs)
    }

    func test_is_confirmed_double_spend__empty_inputs__returns_false() {
        let tx = Transaction()
        XCTAssertFalse(tx.isConfirmedDoubleSpend)
    }

    func test_is_confirmed_double_spend__default_input__returns_false() {
        let tx = Transaction(inputs: [Input()])
        XCTAssertFalse(tx.isConfirmedDoubleSpend)
    }

    func test_is_dusty__no_outputs_zero__returns_false() {
        let tx = Transaction()
        XCTAssertFalse(tx.isDusty(minimumOutputValue: 0))
    }

    func test_is_dusty__two_outputs_limit_above_both__returns_true() {
        XCTAssertTrue(TX1.isDusty(minimumOutputValue: 1740950001))
    }

    func test_is_dusty__two_outputs_limit_below_both__returns_false() {
        XCTAssertFalse(TX1.isDusty(minimumOutputValue: 257999999))
    }

    func test_is_dusty__two_outputs_limit_at_upper__returns_true() {
        XCTAssertTrue(TX1.isDusty(minimumOutputValue: 1740950000))
    }

    func test_is_dusty__two_outputs_limit_at_lower__returns_false() {
        XCTAssertFalse(TX1.isDusty(minimumOutputValue: 258000000))
    }

    func test_is_dusty__two_outputs_limit_between_both__returns_true() {
        XCTAssertTrue(TX1.isDusty(minimumOutputValue: 258000001))
    }

    func test_is_mature__no_inputs__returns_true() {
        let tx = Transaction()
        XCTAssertTrue(tx.isMature(height: 453))
    }

    func test_is_internal_double_spend__empty_prevouts__false() {
        let tx = Transaction()
        XCTAssertFalse(tx.isInternalDoubleSpend)

    }

    lazy var TX7_HASH = try! "cb1e303db604f066225eb14d59d3f8d2231200817bc9d4610d2802586bd93f8a" |> hashDecode

    func test_is_internal_double_spend__unique_prevouts__false() {
        let tx = Transaction(inputs: [
            Input(previousOutput: OutputPoint(hash: TX1_HASH, index: 42)),
            Input(previousOutput: OutputPoint(hash: TX4_HASH, index: 27)),
            Input(previousOutput: OutputPoint(hash: TX7_HASH, index: 36))
            ])
        XCTAssertFalse(tx.isInternalDoubleSpend)
    }

    func test_is_internal_double_spend__nonunique_prevouts__true() {
        let tx = Transaction(inputs: [
            Input(previousOutput: OutputPoint(hash: TX1_HASH, index: 42)),
            Input(previousOutput: OutputPoint(hash: TX4_HASH, index: 27)),
            Input(previousOutput: OutputPoint(hash: TX7_HASH, index: 36)),
            Input(previousOutput: OutputPoint(hash: TX7_HASH, index: 36))
            ])
        XCTAssertTrue(tx.isInternalDoubleSpend)
    }

    func test_crypto_wallet_transaction() {
        let network = Network.testnet

        var tx = Transaction()
        tx.version = 1

        let mnemonic = "priority tuition mutual grain camp mention ask aerobic either pill home harbor elephant skate follow man taste arrange again canal have dad route warm" |> tagMnemonic
        let seed = try! mnemonic |> toSeed
        let version = HDKeyVersion.findVersion(coinType: .btc, network: network, encoding: .p2pkh)!
        let masterHDKey = try! seed |> newHDPrivateKey(hdKeyVersion: version)
        XCTAssertEqual(masterHDKey, "tprv8ZgxMBicQKsPdFdL5FzccNSkQT1kJFrP3fjiHLQzePq3pugG2NBM2rA6ZD5ywLj3ghYSEz9G13nqyW6SXkGnSLNPfaUzbGFrGgJenw47r1W" |> tagHDKey)

        let sourcePublicKey = try! (masterHDKey |> toHDPublicKey |> toECKey) as! ECCompressedPublicKey
        let sourceAddress =  try! sourcePublicKey |> toECPaymentAddress(network: network, type: .p2kh)
        XCTAssertEqual(sourceAddress, "msonra6g9YqYYam28gmfcc1qMaC7qnYPh5" |> tagPaymentAddress)

        let sourceTxHash = try! "af55a1bf3098c7d37d56163c0bc690ba2f6ed7c2c37d94fdc0c0ab5fd11d6b77" |> hashDecode
        let sourceInputIndex = 1
        let sourceUnspentAmount: Satoshis = 12510365
        let outputPoint = OutputPoint(hash: sourceTxHash, index: sourceInputIndex)

        let input = Input(previousOutput: outputPoint)
        tx.inputs = [input]

        let destinationAmount = try! "0.01" |> tagBase10 |> btcToSatoshi
        let feeAmount = 17000 |> tagSatoshis
        let changeAmount = sourceUnspentAmount - destinationAmount - feeAmount

        let destinationAddress = "muR84gYDr49gjEEt942o3WJzFBnb4yMQXG" |> tagPaymentAddress
        let destinationAddressHash = try! destinationAddress |> getHash
        let destinationLockingOperations = Script.makePayKeyHashPattern(hash: destinationAddressHash)
        let destinationLockingScript = Script(destinationLockingOperations)

        let manuallyConstructedDestLockOps: [ScriptOperation] = try! [
            .init(.dup),
            .init(.hash160),
            .init(destinationAddressHash®),
            .init(.equalverify),
            .init(.checksig)
        ]
        XCTAssertEqual(destinationLockingOperations, manuallyConstructedDestLockOps)

        let destinationOutput = Output(value: destinationAmount, script: destinationLockingScript)

        let changeAddress = sourceAddress
        let changeAddressHash = try! changeAddress |> getHash
        let changeLockingOperations = Script.makePayKeyHashPattern(hash: changeAddressHash)
        let changeLockingScript = Script(changeLockingOperations)

        let changeOutput = Output(value: changeAmount, script: changeLockingScript)

        tx.outputs = [destinationOutput, changeOutput]

        //print(try! tx |> serialize |> transactionDecode)


        // signature
        let sourcePrivateKey = try! masterHDKey |> toECPrivateKey
        let prevScript0 = try! Script.makePayKeyHashPattern(hash: sourceAddress |> getHash)
        let sig0 = try! createEndorsement(privateKey: sourcePrivateKey, script: Script(prevScript0), transaction: tx, inputIndex: 0, sigHashType: .all)

//        // Redeem Script
//        let redeemScriptOps = Script.makePayMultisigPattern(requiredSignatureCount: 1, publicKeys: [sourcePublicKey])
//        let redeemScript = Script(redeemScriptOps)
//        print(redeemScript)
//        print(redeemScript |> serialize |> toBitcoin160 |> rawValue |> toBase16)

        // input script
        var sigScript0: [ScriptOperation] = []
        sigScript0.append(try! ScriptOperation(sig0®))
        sigScript0.append(try! ScriptOperation(sourcePublicKey®))
//        sigScript0.append(try! Operation(data: redeemScript |> serialize))
        let myInputScript0 = Script(sigScript0)
        //print(myInputScript0)
        tx.inputs[0].script = myInputScript0
        //print(try! tx |> serialize |> transactionDecode)
        XCTAssertEqual(tx |> serialize |> toBase16, "0100000001776b1dd15fabc0c0fd947dc3c2d76e2fba90c60b3c16567dd3c79830bfa155af010000006a47304402201061a60d0a0260ea26eff4bff2fc6bd90258630d8774152d8a6afed7f311076602200c2eb64a4f91f699a4173ef126ea26133487292a4e81fbc2e0e33fb168b5426c01210337c025321af12dfc4517159d9bd98164dd2ff9fbd7971b29d0aa271d72c404caffffffff0240420f00000000001976a91498776b9b0155331a7e86e0b0f925e8fea526478888acf55faf00000000001976a91486d0b38080ded041b9585e3ffdff3f7535dd24c188ac00000000")
    }
}
