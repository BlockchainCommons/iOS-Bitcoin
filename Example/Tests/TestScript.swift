//
//  TestScript.swift
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

class TestScript: XCTestCase {
    func testScriptDecode() {
        let f = base16Decode >>> scriptDecode
        XCTAssert(try! "76a91418c0bd8d1818f1bf99cb1df2269c645318ef7b7388ac" |> f == "dup hash160 [18c0bd8d1818f1bf99cb1df2269c645318ef7b73] equalverify checksig")
        XCTAssert(try! "04cf2e5b02d6f02340f5a9defbbf710c388b8451c82145b1419fe9696837b1cdefc569a2a79baa6da2f747c3b35a102a081dfd5e799abc41262103e0d17114770b" |> f == "[cf2e5b02] 0xd6 0xf0 [40f5a9defbbf710c388b8451c82145b1419fe9696837b1cdefc569a2a79baa6da2f747] 0xc3 nop4 10 [2a081dfd5e799abc41262103e0d17114] nip <invalid>")
        XCTAssert(try! "4730440220688fb2aef767f21127b375d50d0ab8f7a1abaecad08e7c4987f7305c90e5a02502203282909b7863149bf4c92589764df80744afb509b949c06bfbeb28864277d88d0121025334b571c11e22967452f195509260f6a6dd10357fc4ad76b1c0aa5981ac254e" |> f == "[30440220688fb2aef767f21127b375d50d0ab8f7a1abaecad08e7c4987f7305c90e5a02502203282909b7863149bf4c92589764df80744afb509b949c06bfbeb28864277d88d01] [025334b571c11e22967452f195509260f6a6dd10357fc4ad76b1c0aa5981ac254e]")
        XCTAssert(try! "" |> f == "")
    }

    func testScriptEncode() {
        let f = scriptEncode >>> base16Encode
        XCTAssert(try! "dup hash160 [18c0bd8d1818f1bf99cb1df2269c645318ef7b73] equalverify checksig" |> f == "76a91418c0bd8d1818f1bf99cb1df2269c645318ef7b7388ac")
        XCTAssertThrowsError(try "foo" |> f == "won't happen") // Invalid script
        XCTAssert(try! "" |> f == "")
    }

    func testScriptToAddress() {
        let s1 = "dup hash160 [89abcdefabbaabbaabbaabbaabbaabbaabbaabba] equalverify checksig"
        XCTAssert(try! s1 |> scriptToAddress == "3F6i6kwkevjR7AsAd4te2YB2zZyASEm1HM")
        XCTAssert(try! s1 |> scriptToAddress(network: .testnet) == "2N6evAVsnGPEmJxViJCWWeVAJCvBLFehT7L")

        let s2 = ["2", "[048cdce248e9d30838a2b31ad7162195db0ef4c20517916fa371fd04b153c214eeb644dcda76a98d33b0180a949d521df1d75024587a28ef30f2906c266fbb360e]", "[04d34775baab521d7ba2bd43997312d5f663633484ae1a4d84246866b7088297715a049e2288ae16f168809d36e2da1162f03412bf23aa5f949f235eb2e7141783]", "[04534072a9a62226252917f3011082a429900bbc5d1e11386b16e64e1dc985259c1cbcea0bad66fa6f106ea617ddddb6de45ac9118a3dcfc29c0763c167d56290e]", "3", "checkmultisig"] |> joined(separator: " ")
        XCTAssert(try! s2 |> scriptToAddress == "3CS58tZGJtjz4qBFyNgQRtneKaWUjeEZVM")
        XCTAssert(try! s2 |> scriptToAddress(network: .testnet) == "2N3zHCdVHvMFLGcooeWJH3qmuXvieWfEFKG")
    }

    let scriptReturn = "return"
    let scriptReturnEmpty = "return []"
    let scriptReturn80 = "return [0001020304050607080900010203040506070809000102030405060708090001020304050607080900010203040506070809000102030405060708090001020304050607080900010203040506070809]"
    let scriptReturn81 = "return [0001020304050607080900010203040506070809000102030405060708090001020304050607080900010203040506070809000102030405060708090001020304050607080900010203040506070809FF]"

    let script0Of3Multisig = "0 [03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864] [02440e0304bf8d32b2012994393c6a477acf238dd6adb4c3cef5bfa72f30c9861c] [03624505c6cc3967352cce480d8550490dd68519cd019066a4c302fdfb7d1c9934] 3 checkmultisig"
    let script1Of3Multisig = "1 [03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864] [02440e0304bf8d32b2012994393c6a477acf238dd6adb4c3cef5bfa72f30c9861c] [03624505c6cc3967352cce480d8550490dd68519cd019066a4c302fdfb7d1c9934] 3 checkmultisig"
    let script2Of3Multisig = "2 [03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864] [02440e0304bf8d32b2012994393c6a477acf238dd6adb4c3cef5bfa72f30c9861c] [03624505c6cc3967352cce480d8550490dd68519cd019066a4c302fdfb7d1c9934] 3 checkmultisig"
    let script3Of3Multisig = "3 [03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864] [02440e0304bf8d32b2012994393c6a477acf238dd6adb4c3cef5bfa72f30c9861c] [03624505c6cc3967352cce480d8550490dd68519cd019066a4c302fdfb7d1c9934] 3 checkmultisig"
    let script4Of3Multisig = "4 [03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864] [02440e0304bf8d32b2012994393c6a477acf238dd6adb4c3cef5bfa72f30c9861c] [03624505c6cc3967352cce480d8550490dd68519cd019066a4c302fdfb7d1c9934] 3 checkmultisig"

    let script16Of16Multisig =
    "16 " +
    "[03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864] " +
    "[02440e0304bf8d32b2012994393c6a477acf238dd6adb4c3cef5bfa72f30c9861c] " +
    "[03624505c6cc3967352cce480d8550490dd68519cd019066a4c302fdfb7d1c9934] " +
    "[03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864] " +
    "[02440e0304bf8d32b2012994393c6a477acf238dd6adb4c3cef5bfa72f30c9861c] " +
    "[03624505c6cc3967352cce480d8550490dd68519cd019066a4c302fdfb7d1c9934] " +
    "[03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864] " +
    "[02440e0304bf8d32b2012994393c6a477acf238dd6adb4c3cef5bfa72f30c9861c] " +
    "[03624505c6cc3967352cce480d8550490dd68519cd019066a4c302fdfb7d1c9934] " +
    "[03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864] " +
    "[02440e0304bf8d32b2012994393c6a477acf238dd6adb4c3cef5bfa72f30c9861c] " +
    "[03624505c6cc3967352cce480d8550490dd68519cd019066a4c302fdfb7d1c9934] " +
    "[03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864] " +
    "[02440e0304bf8d32b2012994393c6a477acf238dd6adb4c3cef5bfa72f30c9861c] " +
    "[03624505c6cc3967352cce480d8550490dd68519cd019066a4c302fdfb7d1c9934] " +
    "[03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864] " +
    "16 checkmultisig"

    let script17Of17Multisig =
    "[17] " +
    "[03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864] " +
    "[02440e0304bf8d32b2012994393c6a477acf238dd6adb4c3cef5bfa72f30c9861c] " +
    "[03624505c6cc3967352cce480d8550490dd68519cd019066a4c302fdfb7d1c9934] " +
    "[03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864] " +
    "[02440e0304bf8d32b2012994393c6a477acf238dd6adb4c3cef5bfa72f30c9861c] " +
    "[03624505c6cc3967352cce480d8550490dd68519cd019066a4c302fdfb7d1c9934] " +
    "[03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864] " +
    "[02440e0304bf8d32b2012994393c6a477acf238dd6adb4c3cef5bfa72f30c9861c] " +
    "[03624505c6cc3967352cce480d8550490dd68519cd019066a4c302fdfb7d1c9934] " +
    "[03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864] " +
    "[02440e0304bf8d32b2012994393c6a477acf238dd6adb4c3cef5bfa72f30c9861c] " +
    "[03624505c6cc3967352cce480d8550490dd68519cd019066a4c302fdfb7d1c9934] " +
    "[03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864] " +
    "[02440e0304bf8d32b2012994393c6a477acf238dd6adb4c3cef5bfa72f30c9861c] " +
    "[03624505c6cc3967352cce480d8550490dd68519cd019066a4c302fdfb7d1c9934] " +
    "[03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864] " +
    "[02440e0304bf8d32b2012994393c6a477acf238dd6adb4c3cef5bfa72f30c9861c] " +
    "16 checkmultisig"

    func test_script__one_hash__literal__same() {
        let hashOne = try! "0000000000000000000000000000000000000000000000000000000000000001" |> hashDecode
        let oneHash = try! HashDigest(Data([1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]))
        XCTAssert(hashOne == oneHash)
    }

    func test_script__from_data__testnet_119058_invalid_op_codes__success() {
        let rawScript = try! "0130323066643366303435313438356531306633383837363437356630643265396130393739343332353534313766653139316438623963623230653430643863333030326431373463336539306366323433393231383761313037623634373337633937333135633932393264653431373731636565613062323563633534353732653302ae" |> base16Decode
        XCTAssertNoThrow(try Script(data: rawScript))
    }

    func test_script__from_data__parse__success() {
        let rawScript = try! "3045022100ff1fc58dbd608e5e05846a8e6b45a46ad49878aef6879ad1a7cf4c5a7f853683022074a6a10f6053ab3cddc5620d169c7374cd42c1416c51b9744db2c8d9febfb84d01" |> base16Decode
        XCTAssertNoThrow(try Script(data: rawScript, prefix: true))
    }

    func test_script__from_data__to_data__roundtrips() {
        let normal_output_script = try! "3045022100ff1fc58dbd608e5e05846a8e6b45a46ad49878aef6879ad1a7cf4c5a7f853683022074a6a10f6053ab3cddc5620d169c7374cd42c1416c51b9744db2c8d9febfb84d01" |> base16Decode
        var out_script: Script!
        XCTAssertNoThrow(out_script = try Script(data: normal_output_script))
        let roundtrip = out_script.data
        XCTAssert(roundtrip == normal_output_script)
    }

    func test_script__from_data__to_data_weird__roundtrips() {
        let weird_raw_script = try! ("0c49206c69656b20636174732e483045022100c7387f64e1f4" +
                    "cf654cae3b28a15f7572106d6c1319ddcdc878e636ccb83845" +
                    "e30220050ebf440160a4c0db5623e0cb1562f46401a7ff5b87" +
                    "7aa03415ae134e8c71c901534d4f0176519c6375522103b124" +
                    "c48bbff7ebe16e7bd2b2f2b561aa53791da678a73d2777cc1c" +
                    "a4619ab6f72103ad6bb76e00d124f07a22680e39debd4dc4bd" +
                    "b1aa4b893720dd05af3c50560fdd52af67529c63552103b124" +
                    "c48bbff7ebe16e7bd2b2f2b561aa53791da678a73d2777cc1c" +
                    "a4619ab6f721025098a1d5a338592bf1e015468ec5a8fafc1f" +
                    "c9217feb5cb33597f3613a2165e9210360cfabc01d52eaaeb3" +
                    "976a5de05ff0cfa76d0af42d3d7e1b4c233ee8a00655ed2103" +
                    "f571540c81fd9dbf9622ca00cfe95762143f2eab6b65150365" +
                    "bb34ac533160432102bc2b4be1bca32b9d97e2d6fb255504f4" +
                    "bc96e01aaca6e29bfa3f8bea65d8865855af672103ad6bb76e" +
                    "00d124f07a22680e39debd4dc4bdb1aa4b893720dd05af3c50" +
                    "560fddada820a4d933888318a23c28fb5fc67aca8530524e20" +
                    "74b1d185dbf5b4db4ddb0642848868685174519c6351670068") |> base16Decode
        var weird: Script!
        XCTAssertNoThrow(weird = try Script(data: weird_raw_script))
        print(weird)
        let roundtrip_result = weird.data
        XCTAssert(roundtrip_result == weird_raw_script)
    }

    func test_script__factory_chunk_test() {
        let raw = try! "76a914fc7b44566256621affb1541cc9d59f08336d276b88ac" |> base16Decode
        let script = try! Script(data: raw)
        XCTAssert(script.isValid)
    }

    func test_script__from_string__empty__success() {
        let script = try! Script(string: "")
        XCTAssert(script.operations.isEmpty)
    }

    func test_script__from_string__two_of_three_multisig__success() {
        let script = try! Script(string: script2Of3Multisig)
        let ops = script.operations
        XCTAssert(ops.count == 6)
        XCTAssert(ops[0].opcode == Opcode.pushPositive2)
        XCTAssert(ops[1] |> toString(rules: .noRules) == "[03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864]")
        XCTAssert(ops[2] |> toString(rules: .noRules) == "[02440e0304bf8d32b2012994393c6a477acf238dd6adb4c3cef5bfa72f30c9861c]")
        XCTAssert(ops[3] |> toString(rules: .noRules) == "[03624505c6cc3967352cce480d8550490dd68519cd019066a4c302fdfb7d1c9934]")
        XCTAssert(ops[4].opcode == Opcode.pushPositive3)
        XCTAssert(ops[5].opcode == Opcode.checkmultisig)
    }

    func test_script__empty__default__true() {
        let script = Script()
        XCTAssert(script.isEmpty)
    }

    func test_script__empty__no_operations__true() {
        let script = Script(operations: [])
        XCTAssert(script.isEmpty)
    }

    func test_script__empty__non_empty__false() {
        let data = try! "2a" |> base16Decode
        let script = Script(operations: Script.makePayNullDataPattern(data: data))
        XCTAssertFalse(script.isEmpty)
    }

    func test_script__clear__non_empty__empty() {
        let data = try! "2a" |> base16Decode
        var script = Script(operations: Script.makePayNullDataPattern(data: data))
        XCTAssertFalse(script.isEmpty)
        script.clear()
        XCTAssert(script.isEmpty)
    }

    func test_script__pattern() {
        func f(_ scriptString: String, outputPattern: ScriptPattern, inputPattern: ScriptPattern, pattern: ScriptPattern) -> Bool {
            let script = try! Script(string: scriptString)
            guard script.isValid else { return false }
            guard script.outputPattern == outputPattern else { return false }
            guard script.inputPattern == inputPattern else { return false }
            guard script.pattern == pattern else { return false }
            return true
        }

        XCTAssert(f(scriptReturn, outputPattern: .nonStandard, inputPattern: .nonStandard, pattern: .nonStandard))
        XCTAssert(f(scriptReturnEmpty, outputPattern: .payNullData, inputPattern: .nonStandard, pattern: .payNullData))
        XCTAssert(f(scriptReturn80, outputPattern: .payNullData, inputPattern: .nonStandard, pattern: .payNullData))
        XCTAssert(f(scriptReturn81, outputPattern: .nonStandard, inputPattern: .nonStandard, pattern: .nonStandard))
        XCTAssert(f(script0Of3Multisig, outputPattern: .nonStandard, inputPattern: .nonStandard, pattern: .nonStandard))
        XCTAssert(f(script1Of3Multisig, outputPattern: .payMultisig, inputPattern: .nonStandard, pattern: .payMultisig))
        XCTAssert(f(script2Of3Multisig, outputPattern: .payMultisig, inputPattern: .nonStandard, pattern: .payMultisig))
        XCTAssert(f(script3Of3Multisig, outputPattern: .payMultisig, inputPattern: .nonStandard, pattern: .payMultisig))
        XCTAssert(f(script4Of3Multisig, outputPattern: .nonStandard, inputPattern: .nonStandard, pattern: .nonStandard))
        XCTAssert(f(script16Of16Multisig, outputPattern: .payMultisig, inputPattern: .nonStandard, pattern: .payMultisig))
        XCTAssert(f(script17Of17Multisig, outputPattern: .nonStandard, inputPattern: .nonStandard, pattern: .nonStandard))
    }

    struct ScriptTest {
        let input: String
        let output: String
        let description: String
        let inputSequence: UInt32
        let lockTime: UInt32
        let version: UInt32

        init(_ input: String, _ output: String, _ description: String, _ inputSequence: UInt32 = 0, _ lockTime: UInt32 = 0, _ version: UInt32 = 0) {
            self.input = input
            self.output = output
            self.description = description
            self.inputSequence = inputSequence
            self.lockTime = lockTime
            self.version = version
        }
    }

    func test_script__bip16__valid() {
        let valid_bip16_scripts = [
            ScriptTest("0 [51]", "hash160 [da1745e9b549bd0bfa1a569971c77eba30cd5a4b] equal", "trivial p2sh"),
            ScriptTest("[1.] [0.51]", "hash160 [da1745e9b549bd0bfa1a569971c77eba30cd5a4b] equal", "basic p2sh")
        ]

        for test in valid_bip16_scripts {
            let inputScript = try! Script(string: test.input)
            let outputScript = try! Script(string: test.output)
            let outputPoint = OutputPoint()
            let input = Input(previousOutput: outputPoint, script: inputScript, sequence: test.inputSequence)
            let tx = Transaction(version: test.version, lockTime: test.lockTime, inputs: [input], outputs: [])
            XCTAssert(tx.isValid)
            XCTAssert(Script.verify(transaction: tx, inputIndex: 0, rules: .noRules, prevoutScript: outputScript, value: 0).isSuccess)
            XCTAssert(Script.verify(transaction: tx, inputIndex: 0, rules: .bip16Rule, prevoutScript: outputScript, value: 0).isSuccess)
            XCTAssert(Script.verify(transaction: tx, inputIndex: 0, rules: .allRules, prevoutScript: outputScript, value: 0).isSuccess)
        }
    }

    func test_script__bip16__invalidated() {
        let invalidated_bip16_scripts = [
            ScriptTest("nop [51]", "hash160 [da1745e9b549bd0bfa1a569971c77eba30cd5a4b] equal", "is_push_only fails under bip16"),
            ScriptTest("nop1 [51]", "hash160 [da1745e9b549bd0bfa1a569971c77eba30cd5a4b] equal", "is_push_only fails under bip16"),
            ScriptTest("0 [50]", "hash160 [ece424a6bb6ddf4db592c0faed60685047a361b1] equal", "op_reserved as p2sh serialized script fails"),
            ScriptTest("0 [62]", "hash160 [0f4d7845db968f2a81b530b6f3c1d6246d4c7e01] equal", "op_ver as p2sh serialized script fails")
        ]
        for test in invalidated_bip16_scripts {
            let inputScript = try! Script(string: test.input)
            let outputScript = try! Script(string: test.output)
            let outputPoint = OutputPoint()
            let input = Input(previousOutput: outputPoint, script: inputScript, sequence: test.inputSequence)
            let tx = Transaction(version: test.version, lockTime: test.lockTime, inputs: [input], outputs: [])
            XCTAssert(tx.isValid)
            XCTAssert(Script.verify(transaction: tx, inputIndex: 0, rules: .noRules, prevoutScript: outputScript, value: 0).isSuccess)
            XCTAssertFalse(Script.verify(transaction: tx, inputIndex: 0, rules: .bip16Rule, prevoutScript: outputScript, value: 0).isSuccess)
            XCTAssertFalse(Script.verify(transaction: tx, inputIndex: 0, rules: .allRules, prevoutScript: outputScript, value: 0).isSuccess)
        }
    }
}
