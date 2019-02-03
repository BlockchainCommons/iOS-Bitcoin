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
import WolfFoundation

class TestScript: XCTestCase {
    func testScriptDecode() {
        let f = tagBase16 >>> toData >>> scriptDecode
        XCTAssert(try! "76a91418c0bd8d1818f1bf99cb1df2269c645318ef7b7388ac" |> f == "dup hash160 [18c0bd8d1818f1bf99cb1df2269c645318ef7b73] equalverify checksig")
        XCTAssert(try! "04cf2e5b02d6f02340f5a9defbbf710c388b8451c82145b1419fe9696837b1cdefc569a2a79baa6da2f747c3b35a102a081dfd5e799abc41262103e0d17114770b" |> f == "[cf2e5b02] 0xd6 0xf0 [40f5a9defbbf710c388b8451c82145b1419fe9696837b1cdefc569a2a79baa6da2f747] 0xc3 nop4 10 [2a081dfd5e799abc41262103e0d17114] nip <invalid>")
        XCTAssert(try! "4730440220688fb2aef767f21127b375d50d0ab8f7a1abaecad08e7c4987f7305c90e5a02502203282909b7863149bf4c92589764df80744afb509b949c06bfbeb28864277d88d0121025334b571c11e22967452f195509260f6a6dd10357fc4ad76b1c0aa5981ac254e" |> f == "[30440220688fb2aef767f21127b375d50d0ab8f7a1abaecad08e7c4987f7305c90e5a02502203282909b7863149bf4c92589764df80744afb509b949c06bfbeb28864277d88d01] [025334b571c11e22967452f195509260f6a6dd10357fc4ad76b1c0aa5981ac254e]")
        XCTAssert(try! "" |> f == "")
    }

    func testScriptEncode() {
        let f = scriptEncode >>> toBase16
        XCTAssert(try! "dup hash160 [18c0bd8d1818f1bf99cb1df2269c645318ef7b73] equalverify checksig" |> f == "76a91418c0bd8d1818f1bf99cb1df2269c645318ef7b7388ac")
        XCTAssertThrowsError(try "foo" |> f == "won't happen") // Invalid script
        XCTAssert(try! "" |> f == "")
    }

    func testScriptToAddress() {
        let s1 = "dup hash160 [89abcdefabbaabbaabbaabbaabbaabbaabbaabba] equalverify checksig"
        XCTAssert(try! s1 |> scriptToAddress(network: .mainnet) == "3F6i6kwkevjR7AsAd4te2YB2zZyASEm1HM")
        XCTAssert(try! s1 |> scriptToAddress(network: .testnet) == "2N6evAVsnGPEmJxViJCWWeVAJCvBLFehT7L")

        let s2 = ["2", "[048cdce248e9d30838a2b31ad7162195db0ef4c20517916fa371fd04b153c214eeb644dcda76a98d33b0180a949d521df1d75024587a28ef30f2906c266fbb360e]", "[04d34775baab521d7ba2bd43997312d5f663633484ae1a4d84246866b7088297715a049e2288ae16f168809d36e2da1162f03412bf23aa5f949f235eb2e7141783]", "[04534072a9a62226252917f3011082a429900bbc5d1e11386b16e64e1dc985259c1cbcea0bad66fa6f106ea617ddddb6de45ac9118a3dcfc29c0763c167d56290e]", "3", "checkmultisig"] |> joined(separator: " ")
        XCTAssert(try! s2 |> scriptToAddress(network: .mainnet) == "3CS58tZGJtjz4qBFyNgQRtneKaWUjeEZVM")
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
        let oneHash = try! Data([1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]) |> tagHashDigest
        XCTAssert(hashOne == oneHash)
    }

    func test_script__from_data__testnet_119058_invalid_op_codes__success() {
        let rawScript = "0130323066643366303435313438356531306633383837363437356630643265396130393739343332353534313766653139316438623963623230653430643863333030326431373463336539306366323433393231383761313037623634373337633937333135633932393264653431373731636565613062323563633534353732653302ae" |> dataLiteral
        XCTAssertNoThrow(try rawScript |> deserializeScript)
    }

    func test_script__from_data__parse__success() {
        let rawScript = "3045022100ff1fc58dbd608e5e05846a8e6b45a46ad49878aef6879ad1a7cf4c5a7f853683022074a6a10f6053ab3cddc5620d169c7374cd42c1416c51b9744db2c8d9febfb84d01" |> dataLiteral
        XCTAssertNoThrow(try Script.deserialize(rawScript, prefix: true))
    }

    func test_script__from_data__to_data__roundtrips() {
        let normal_output_script = "3045022100ff1fc58dbd608e5e05846a8e6b45a46ad49878aef6879ad1a7cf4c5a7f853683022074a6a10f6053ab3cddc5620d169c7374cd42c1416c51b9744db2c8d9febfb84d01" |> dataLiteral
        var out_script: Script!
        XCTAssertNoThrow(out_script = try normal_output_script |> deserializeScript)
        let roundtrip = out_script |> serialize
        XCTAssert(roundtrip == normal_output_script)
    }

    func test_script__from_data__to_data_weird__roundtrips() {
        let weird_raw_script = ("0c49206c69656b20636174732e483045022100c7387f64e1f4" +
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
                    "74b1d185dbf5b4db4ddb0642848868685174519c6351670068") |> dataLiteral
        var weird: Script!
        XCTAssertNoThrow(weird = try weird_raw_script |> deserializeScript)
        let roundtrip_result = weird |> serialize
        XCTAssert(roundtrip_result == weird_raw_script)
    }

    func test_script__factory_chunk_test() {
        let raw = "76a914fc7b44566256621affb1541cc9d59f08336d276b88ac" |> dataLiteral
        let script = try! raw |> deserializeScript
        XCTAssert(script.isValid)
    }

    func test_script__from_string__empty__success() {
        let script = try! Script("")
        XCTAssert(script.operations.isEmpty)
    }

    func test_script__from_string__two_of_three_multisig__success() {
        let script = try! Script(script2Of3Multisig)
        let ops = script.operations
        XCTAssert(ops.count == 6)
        XCTAssert(ops[0].opcode == .pushPositive2)
        XCTAssert(ops[1] |> toString(rules: .noRules) == "[03dcfd9e580de35d8c2060d76dbf9e5561fe20febd2e64380e860a4d59f15ac864]")
        XCTAssert(ops[2] |> toString(rules: .noRules) == "[02440e0304bf8d32b2012994393c6a477acf238dd6adb4c3cef5bfa72f30c9861c]")
        XCTAssert(ops[3] |> toString(rules: .noRules) == "[03624505c6cc3967352cce480d8550490dd68519cd019066a4c302fdfb7d1c9934]")
        XCTAssert(ops[4].opcode == .pushPositive3)
        XCTAssert(ops[5].opcode == .checkmultisig)
    }

    func test_script__empty__default__true() {
        let script = Script()
        XCTAssert(script.isEmpty)
    }

    func test_script__empty__no_operations__true() {
        let script = Script([])
        XCTAssert(script.isEmpty)
    }

    func test_script__empty__non_empty__false() {
        let data = "2a" |> dataLiteral
        let script = Script(Script.makePayNullDataPattern(data: data))
        XCTAssertFalse(script.isEmpty)
    }

    func test_script__clear__non_empty__empty() {
        let data = "2a" |> dataLiteral
        var script = Script(Script.makePayNullDataPattern(data: data))
        XCTAssertFalse(script.isEmpty)
        script.clear()
        XCTAssert(script.isEmpty)
    }

    func test_script__pattern() {
        func f(_ scriptString: String, outputPattern: ScriptPattern, inputPattern: ScriptPattern, pattern: ScriptPattern) -> Bool {
            let script = try! Script(scriptString)
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

    func makeTransaction(for test: ScriptTest) -> (Transaction, Script) {
        let inputScript = try! Script(test.input)
        let outputScript = try! Script(test.output)
        let outputPoint = OutputPoint()
        let input = Input(previousOutput: outputPoint, script: inputScript, sequence: test.inputSequence)
        let tx = Transaction(version: test.version, lockTime: test.lockTime, inputs: [input], outputs: [])
        return (tx, outputScript)
    }

    func verifyScript(_ test: ScriptTest, _ transaction: Transaction, _ prevoutScript: Script, _ rules: RuleFork, _ expectSuccess: Bool) -> Bool {
        let code = Script.verify(transaction: transaction, inputIndex: 0, rules: rules, prevoutScript: prevoutScript, value: 0)
        guard code.isSuccess == expectSuccess else {
            print("❌ \(test.description)")
            return false
        }
        return true
    }

    func test_script__bip16__valid() {
        let valid_bip16_scripts = [
            ScriptTest("0 [51]", "hash160 [da1745e9b549bd0bfa1a569971c77eba30cd5a4b] equal", "trivial p2sh"),
            ScriptTest("[1.] [0.51]", "hash160 [da1745e9b549bd0bfa1a569971c77eba30cd5a4b] equal", "basic p2sh")
        ]

        for test in valid_bip16_scripts {
            let (tx, outputScript) = makeTransaction(for: test)
            XCTAssert(tx.isValid)
            XCTAssert(verifyScript(test, tx, outputScript, .noRules, true))
            XCTAssert(verifyScript(test, tx, outputScript, .bip16Rule, true))
            XCTAssert(verifyScript(test, tx, outputScript, .allRules, true))
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
            let (tx, outputScript) = makeTransaction(for: test)
            XCTAssert(tx.isValid)
            XCTAssert(verifyScript(test, tx, outputScript, .noRules, true))
            XCTAssert(verifyScript(test, tx, outputScript, .bip16Rule, false))
            XCTAssert(verifyScript(test, tx, outputScript, .allRules, false))
        }
    }

    func test_script__bip65__valid() {
        let valid_bip65_scripts = [
            ScriptTest("42", "checklocktimeverify", "valid cltv, true return", 42, 99),
            ScriptTest("42", "nop1 nop2 nop3 nop4 nop5 nop6 nop7 nop8 nop9 nop10 [2a] equal", "bip112 would fail nop3", 42, 99)
        ]

        for test in valid_bip65_scripts {
            let (tx, outputScript) = makeTransaction(for: test)
            XCTAssert(tx.isValid)
            XCTAssert(verifyScript(test, tx, outputScript, .noRules, true))
            XCTAssert(verifyScript(test, tx, outputScript, .bip65Rule, true))
            XCTAssert(verifyScript(test, tx, outputScript, .allRules |> remove(.bip112Rule), true))
        }
    }

    func test_script__bip65__invalid() {
        let invalid_bip65_scripts = [
            ScriptTest("", "nop2", "empty nop2", 42, 99 ),
            ScriptTest("", "checklocktimeverify", "empty cltv", 42, 99 )
        ]

        for test in invalid_bip65_scripts {
            let (tx, outputScript) = makeTransaction(for: test)
            XCTAssert(tx.isValid)
            XCTAssert(verifyScript(test, tx, outputScript, .noRules, false))
            XCTAssert(verifyScript(test, tx, outputScript, .bip65Rule, false))
            XCTAssert(verifyScript(test, tx, outputScript, .allRules |> remove(.bip112Rule), false))
        }
    }

    func test_script__bip65__invalidated() {
        let invalidated_bip65_scripts = [
            ScriptTest("1 -1", "checklocktimeverify", "negative cltv", 42, 99),
            ScriptTest("1 100", "checklocktimeverify", "exceeded cltv", 42, 99),
            ScriptTest("1 500000000", "checklocktimeverify", "mismatched cltv", 42, 99),
            ScriptTest("'nop_1_to_10' nop1 nop2 nop3 nop4 nop5 nop6 nop7 nop8 nop9 nop10", "'nop_1_to_10' equal", "bip112 would fail nop3", 42, 99),
            ScriptTest("nop", "nop2 1", "", 42, 99)
        ]

        for test in invalidated_bip65_scripts {
            let (tx, outputScript) = makeTransaction(for: test)
            XCTAssert(tx.isValid)
            XCTAssert(verifyScript(test, tx, outputScript, .noRules, true))
            XCTAssert(verifyScript(test, tx, outputScript, .bip65Rule, false))
            XCTAssert(verifyScript(test, tx, outputScript, .allRules |> remove(.bip112Rule), false))
        }
    }

    func test_script__multisig__valid() {
        let valid_multisig_scripts = [
            ScriptTest("", "0 0 0 checkmultisig verify depth 0 equal", "checkmultisig is allowed to have zero keys and/or sigs"),
            ScriptTest("", "0 0 0 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 0 1 checkmultisig verify depth 0 equal", "zero sigs means no sigs are checked"),
            ScriptTest("", "0 0 0 1 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 2 checkmultisig verify depth 0 equal", "test from up to 20 pubkeys, all not checked"),
            ScriptTest("", "0 0 'a' 'b' 'c' 3 checkmultisig verify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 4 checkmultisig verify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 5 checkmultisig verify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 6 checkmultisig verify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 7 checkmultisig verify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 8 checkmultisig verify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 9 checkmultisig verify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 10 checkmultisig verify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 11 checkmultisig verify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 12 checkmultisig verify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 13 checkmultisig verify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 14 checkmultisig verify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 15 checkmultisig verify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 16 checkmultisig verify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 17 checkmultisig verify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 18 checkmultisig verify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 19 checkmultisig verify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig verify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 1 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 2 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 3 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 4 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 5 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 6 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 7 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 8 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 9 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 10 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 11 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 12 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 13 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 14 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 15 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 16 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 17 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 18 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 19 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify depth 0 equal", ""),
            ScriptTest("", "0 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig", "nopcount is incremented by the number of keys evaluated in addition to the usual one op per op. in this case we have zero keys, so we can execute 201 checkmultisigs"),
            ScriptTest("1", "0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify 0 0 0 checkmultisigverify", ""),
            ScriptTest("", "nop nop nop nop nop nop nop nop nop nop nop nop 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig", "even though there are no signatures being checked nopcount is incremented by the number of keys."),
            ScriptTest("1", "nop nop nop nop nop nop nop nop nop nop nop nop 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify", "")
        ]

        for test in valid_multisig_scripts {
            let (tx, outputScript) = makeTransaction(for: test)
            XCTAssert(tx.isValid)
            XCTAssert(verifyScript(test, tx, outputScript, .noRules, true))
            XCTAssert(verifyScript(test, tx, outputScript, .bip66Rule, true))
            XCTAssert(verifyScript(test, tx, outputScript, .allRules, true))
        }
    }

    func test_script__multisig__invalid() {
        let invalid_multisig_scripts = [
            ScriptTest("", "0 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig 0 0 checkmultisig", "202 checkmultisigs, fails due to 201 op limit"),
            ScriptTest("1", "0 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify 0 0 checkmultisigverify", ""),
            ScriptTest("", "nop nop nop nop nop nop nop nop nop nop nop nop nop 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisig", "fails due to 201 sig op limit"),
            ScriptTest("1", "nop nop nop nop nop nop nop nop nop nop nop nop nop 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify 0 0 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'i' 'j' 'k' 'l' 'm' 'n' 'o' 'p' 'q' 'r' 's' 't' 20 checkmultisigverify", ""),
        ]

        for test in invalid_multisig_scripts {
            let (tx, outputScript) = makeTransaction(for: test)
            XCTAssert(tx.isValid)
            XCTAssert(verifyScript(test, tx, outputScript, .noRules, false))
            XCTAssert(verifyScript(test, tx, outputScript, .bip66Rule, false))
            XCTAssert(verifyScript(test, tx, outputScript, .allRules |> remove(.bip112Rule), false))
        }
    }

    func test_script__context_free__valid() {
        let valid_context_free_scripts = [
            ScriptTest("", "depth 0 equal", "test the test: we should have an empty stack after scriptsig evaluation"),
            ScriptTest("  ", "depth 0 equal", "and multiple spaces should not change that."),
            ScriptTest("   ", "depth 0 equal", ""),
            ScriptTest("    ", "depth 0 equal", ""),
            ScriptTest("1 2", "2 equalverify 1 equal", "similarly whitespace around and between symbols"),
            ScriptTest("1  2", "2 equalverify 1 equal", ""),
            ScriptTest("  1  2", "2 equalverify 1 equal", ""),
            ScriptTest("1  2  ", "2 equalverify 1 equal", ""),
            ScriptTest("  1  2  ", "2 equalverify 1 equal", ""),
            ScriptTest("1", "", ""),
            ScriptTest("[0b]", "11 equal", "push 1 byte"),
            ScriptTest("[417a]", "'Az' equal", "push 2 bytes"),
            ScriptTest("[417a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a7a]", "'Azzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz' equal", "push 75 bytes"),
            ScriptTest("[1.07]", "7 equal", "non-minimal op_pushdata1"),
            ScriptTest("[2.08]", "8 equal", "non-minimal op_pushdata2"),
            ScriptTest("[4.09]", "9 equal", "non-minimal op_pushdata4"),
            ScriptTest("0x4c", "0 equal", "0x4c is op_pushdata1"),
            ScriptTest("0x4d", "0 equal", "0x4d is op_pushdata2"),
            ScriptTest("0x4e", "0 equal", "0x4f is op_pushdata4"),
            ScriptTest("0x4f 1000 add", "999 equal", "1000 - 1 = 999"),
            ScriptTest("0", "if 0x50 endif 1", "0x50 is reserved (ok if not executed)"),
            ScriptTest("0x51", "0x5f add 0x60 equal", "0x51 through 0x60 push 1 through 16 onto stack"),
            ScriptTest("1", "nop", ""),
            ScriptTest("0", "if ver else 1 endif", "ver non-functional (ok if not executed)"),
            ScriptTest("0", "if reserved reserved1 reserved2 else 1 endif", "reserved ok in un-executed if"),
            ScriptTest("1", "dup if endif", ""),
            ScriptTest("1", "if 1 endif", ""),
            ScriptTest("1", "dup if else endif", ""),
            ScriptTest("1", "if 1 else endif", ""),
            ScriptTest("0", "if else 1 endif", ""),
            ScriptTest("1 1", "if if 1 else 0 endif endif", ""),
            ScriptTest("1 0", "if if 1 else 0 endif endif", ""),
            ScriptTest("1 1", "if if 1 else 0 endif else if 0 else 1 endif endif", ""),
            ScriptTest("0 0", "if if 1 else 0 endif else if 0 else 1 endif endif", ""),
            ScriptTest("1 0", "notif if 1 else 0 endif endif", ""),
            ScriptTest("1 1", "notif if 1 else 0 endif endif", ""),
            ScriptTest("1 0", "notif if 1 else 0 endif else if 0 else 1 endif endif", ""),
            ScriptTest("0 1", "notif if 1 else 0 endif else if 0 else 1 endif endif", ""),
            ScriptTest("0", "if 0 else 1 else 0 endif", "multiple else's are valid and executed inverts on each else encountered"),
            ScriptTest("1", "if 1 else 0 else endif", ""),
            ScriptTest("1", "if else 0 else 1 endif", ""),
            ScriptTest("1", "if 1 else 0 else 1 endif add 2 equal", ""),
            ScriptTest("'' 1", "if sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 endif [68ca4fec736264c13b859bac43d5173df6871682] equal", ""),
            ScriptTest("1", "notif 0 else 1 else 0 endif", "multiple else's are valid and execution inverts on each else encountered"),
            ScriptTest("0", "notif 1 else 0 else endif", ""),
            ScriptTest("0", "notif else 0 else 1 endif", ""),
            ScriptTest("0", "notif 1 else 0 else 1 endif add 2 equal", ""),
            ScriptTest("'' 0", "notif sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 else else sha1 endif [68ca4fec736264c13b859bac43d5173df6871682] equal", ""),
            ScriptTest("0", "if 1 if return else return else return endif else 1 if 1 else return else 1 endif else return endif add 2 equal", "nested else else"),
            ScriptTest("1", "notif 0 notif return else return else return endif else 0 notif 1 else return else 1 endif else return endif add 2 equal", ""),
            ScriptTest("0", "if return endif 1", "return only works if executed"),
            ScriptTest("1 1", "verify", ""),
            ScriptTest("10 0 11 toaltstack drop fromaltstack", "add 21 equal", ""),
            ScriptTest("'gavin_was_here' toaltstack 11 fromaltstack", "'gavin_was_here' equalverify 11 equal", ""),
            ScriptTest("0 ifdup", "depth 1 equalverify 0 equal", ""),
            ScriptTest("1 ifdup", "depth 2 equalverify 1 equalverify 1 equal", ""),
            ScriptTest("0 drop", "depth 0 equal", ""),
            ScriptTest("0", "dup 1 add 1 equalverify 0 equal", ""),
            ScriptTest("0 1", "nip", ""),
            ScriptTest("1 0", "over depth 3 equalverify", ""),
            ScriptTest("22 21 20", "0 pick 20 equalverify depth 3 equal", ""),
            ScriptTest("22 21 20", "1 pick 21 equalverify depth 3 equal", ""),
            ScriptTest("22 21 20", "2 pick 22 equalverify depth 3 equal", ""),
            ScriptTest("22 21 20", "0 roll 20 equalverify depth 2 equal", ""),
            ScriptTest("22 21 20", "1 roll 21 equalverify depth 2 equal", ""),
            ScriptTest("22 21 20", "2 roll 22 equalverify depth 2 equal", ""),
            ScriptTest("22 21 20", "rot 22 equal", ""),
            ScriptTest("22 21 20", "rot drop 20 equal", ""),
            ScriptTest("22 21 20", "rot drop drop 21 equal", ""),
            ScriptTest("22 21 20", "rot rot 21 equal", ""),
            ScriptTest("22 21 20", "rot rot rot 20 equal", ""),
            ScriptTest("25 24 23 22 21 20", "rot2 24 equal", ""),
            ScriptTest("25 24 23 22 21 20", "rot2 drop 25 equal", ""),
            ScriptTest("25 24 23 22 21 20", "rot2 drop2 20 equal", ""),
            ScriptTest("25 24 23 22 21 20", "rot2 drop2 drop 21 equal", ""),
            ScriptTest("25 24 23 22 21 20", "rot2 drop2 drop2 22 equal", ""),
            ScriptTest("25 24 23 22 21 20", "rot2 drop2 drop2 drop 23 equal", ""),
            ScriptTest("25 24 23 22 21 20", "rot2 rot2 22 equal", ""),
            ScriptTest("25 24 23 22 21 20", "rot2 rot2 rot2 20 equal", ""),
            ScriptTest("1 0", "swap 1 equalverify 0 equal", ""),
            ScriptTest("0 1", "tuck depth 3 equalverify swap drop2", ""),
            ScriptTest("13 14", "dup2 rot equalverify equal", ""),
            ScriptTest("-1 0 1 2", "dup3 depth 7 equalverify add add 3 equalverify drop2 0 equalverify", ""),
            ScriptTest("1 2 3 5", "over2 add add 8 equalverify add add 6 equal", ""),
            ScriptTest("1 3 5 7", "swap2 add 4 equalverify add 12 equal", ""),
            ScriptTest("0", "size 0 equal", ""),
            ScriptTest("1", "size 1 equal", ""),
            ScriptTest("127", "size 1 equal", ""),
            ScriptTest("128", "size 2 equal", ""),
            ScriptTest("32767", "size 2 equal", ""),
            ScriptTest("32768", "size 3 equal", ""),
            ScriptTest("8388607", "size 3 equal", ""),
            ScriptTest("8388608", "size 4 equal", ""),
            ScriptTest("2147483647", "size 4 equal", ""),
            ScriptTest("2147483648", "size 5 equal", ""),
            ScriptTest("549755813887", "size 5 equal", ""),
            ScriptTest("549755813888", "size 6 equal", ""),
            ScriptTest("9223372036854775807", "size 8 equal", ""),
            ScriptTest("-1", "size 1 equal", ""),
            ScriptTest("-127", "size 1 equal", ""),
            ScriptTest("-128", "size 2 equal", ""),
            ScriptTest("-32767", "size 2 equal", ""),
            ScriptTest("-32768", "size 3 equal", ""),
            ScriptTest("-8388607", "size 3 equal", ""),
            ScriptTest("-8388608", "size 4 equal", ""),
            ScriptTest("-2147483647", "size 4 equal", ""),
            ScriptTest("-2147483648", "size 5 equal", ""),
            ScriptTest("-549755813887", "size 5 equal", ""),
            ScriptTest("-549755813888", "size 6 equal", ""),
            ScriptTest("-9223372036854775807", "size 8 equal", ""),
            ScriptTest("'abcdefghijklmnopqrstuvwxyz'", "size 26 equal", ""),
            ScriptTest("2 -2 add", "0 equal", ""),
            ScriptTest("2147483647 -2147483647 add", "0 equal", ""),
            ScriptTest("-1 -1 add", "-2 equal", ""),
            ScriptTest("0 0", "equal", ""),
            ScriptTest("1 1 add", "2 equal", ""),
            ScriptTest("1 add1", "2 equal", ""),
            ScriptTest("111 sub1", "110 equal", ""),
            ScriptTest("111 1 add 12 sub", "100 equal", ""),
            ScriptTest("0 abs", "0 equal", ""),
            ScriptTest("16 abs", "16 equal", ""),
            ScriptTest("-16 abs", "-16 negate equal", ""),
            ScriptTest("0 not", "nop", ""),
            ScriptTest("1 not", "0 equal", ""),
            ScriptTest("11 not", "0 equal", ""),
            ScriptTest("0 nonzero", "0 equal", ""),
            ScriptTest("1 nonzero", "1 equal", ""),
            ScriptTest("111 nonzero", "1 equal", ""),
            ScriptTest("-111 nonzero", "1 equal", ""),
            ScriptTest("1 1 booland", "nop", ""),
            ScriptTest("1 0 booland", "not", ""),
            ScriptTest("0 1 booland", "not", ""),
            ScriptTest("0 0 booland", "not", ""),
            ScriptTest("16 17 booland", "nop", ""),
            ScriptTest("1 1 boolor", "nop", ""),
            ScriptTest("1 0 boolor", "nop", ""),
            ScriptTest("0 1 boolor", "nop", ""),
            ScriptTest("0 0 boolor", "not", ""),
            ScriptTest("16 17 boolor", "nop", ""),
            ScriptTest("11 10 1 add", "numequal", ""),
            ScriptTest("11 10 1 add", "numequalverify 1", ""),
            ScriptTest("11 10 1 add", "numnotequal not", ""),
            ScriptTest("111 10 1 add", "numnotequal", ""),
            ScriptTest("11 10", "lessthan not", ""),
            ScriptTest("4 4", "lessthan not", ""),
            ScriptTest("10 11", "lessthan", ""),
            ScriptTest("-11 11", "lessthan", ""),
            ScriptTest("-11 -10", "lessthan", ""),
            ScriptTest("11 10", "greaterthan", ""),
            ScriptTest("4 4", "greaterthan not", ""),
            ScriptTest("10 11", "greaterthan not", ""),
            ScriptTest("-11 11", "greaterthan not", ""),
            ScriptTest("-11 -10", "greaterthan not", ""),
            ScriptTest("11 10", "lessthanorequal not", ""),
            ScriptTest("4 4", "lessthanorequal", ""),
            ScriptTest("10 11", "lessthanorequal", ""),
            ScriptTest("-11 11", "lessthanorequal", ""),
            ScriptTest("-11 -10", "lessthanorequal", ""),
            ScriptTest("11 10", "greaterthanorequal", ""),
            ScriptTest("4 4", "greaterthanorequal", ""),
            ScriptTest("10 11", "greaterthanorequal not", ""),
            ScriptTest("-11 11", "greaterthanorequal not", ""),
            ScriptTest("-11 -10", "greaterthanorequal not", ""),
            ScriptTest("1 0 min", "0 numequal", ""),
            ScriptTest("0 1 min", "0 numequal", ""),
            ScriptTest("-1 0 min", "-1 numequal", ""),
            ScriptTest("0 -2147483647 min", "-2147483647 numequal", ""),
            ScriptTest("2147483647 0 max", "2147483647 numequal", ""),
            ScriptTest("0 100 max", "100 numequal", ""),
            ScriptTest("-100 0 max", "0 numequal", ""),
            ScriptTest("0 -2147483647 max", "0 numequal", ""),
            ScriptTest("0 0 1", "within", ""),
            ScriptTest("1 0 1", "within not", ""),
            ScriptTest("0 -2147483647 2147483647", "within", ""),
            ScriptTest("-1 -100 100", "within", ""),
            ScriptTest("11 -100 100", "within", ""),
            ScriptTest("-2147483647 -100 100", "within not", ""),
            ScriptTest("2147483647 -100 100", "within not", ""),
            ScriptTest("2147483647 2147483647 sub", "0 equal", ""),
            ScriptTest("2147483647 dup add", "4294967294 equal", ">32 bit equal is valid"),
            ScriptTest("2147483647 negate dup add", "-4294967294 equal", ""),
            ScriptTest("''", "ripemd160 [9c1185a5c5e9fc54612808977ee8f548b2258d31] equal", ""),
            ScriptTest("'a'", "ripemd160 [0bdc9d2d256b3ee9daae347be6f4dc835a467ffe] equal", ""),
            ScriptTest("'abcdefghijklmnopqrstuvwxyz'", "ripemd160 [f71c27109c692c1b56bbdceb5b9d2865b3708dbc] equal", ""),
            ScriptTest("''", "sha1 [da39a3ee5e6b4b0d3255bfef95601890afd80709] equal", ""),
            ScriptTest("'a'", "sha1 [86f7e437faa5a7fce15d1ddcb9eaeaea377667b8] equal", ""),
            ScriptTest("'abcdefghijklmnopqrstuvwxyz'", "sha1 [32d10c7b8cf96570ca04ce37f2a19d84240d3a89] equal", ""),
            ScriptTest("''", "sha256 [e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855] equal", ""),
            ScriptTest("'a'", "sha256 [ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb] equal", ""),
            ScriptTest("'abcdefghijklmnopqrstuvwxyz'", "sha256 [71c480df93d6ae2f1efad1447c66c9525e316218cf51fc8d9ed832f2daf18b73] equal", ""),
            ScriptTest("''", "dup hash160 swap sha256 ripemd160 equal", ""),
            ScriptTest("''", "dup hash256 swap sha256 sha256 equal", ""),
            ScriptTest("''", "nop hash160 [b472a266d0bd89c13706a4132ccfb16f7c3b9fcb] equal", ""),
            ScriptTest("'a'", "hash160 nop [994355199e516ff76c4fa4aab39337b9d84cf12b] equal", ""),
            ScriptTest("'abcdefghijklmnopqrstuvwxyz'", "hash160 [1.c286a1af0947f58d1ad787385b1c2c4a976f9e71] equal", ""),
            ScriptTest("''", "hash256 [5df6e0e2761359d30a8275058e299fcc0381534545f55cf43e41983f5d4c9456] equal", ""),
            ScriptTest("'a'", "hash256 [bf5d3affb73efd2ec6c36ad3112dd933efed63c4e1cbffcfa88e2759c144f2d8] equal", ""),
            ScriptTest("'abcdefghijklmnopqrstuvwxyz'", "hash256 [1.ca139bc10c2f660da42666f72e89a225936fc60f193c161124a672050c434671] equal", ""),
            ScriptTest("1", "nop1 nop4 nop5 nop6 nop7 nop8 nop9 nop10 1 equal", ""),

            ScriptTest("'nop_1_to_10' nop1 nop4 nop5 nop6 nop7 nop8 nop9 nop10", "'nop_1_to_10' equal", ""),
            ScriptTest("0", "if 0xba else 1 endif", "opcodes above nop10 invalid if executed"),
            ScriptTest("0", "if 0xbb else 1 endif", ""),
            ScriptTest("0", "if 0xbc else 1 endif", ""),
            ScriptTest("0", "if 0xbd else 1 endif", ""),
            ScriptTest("0", "if 0xbe else 1 endif", ""),
            ScriptTest("0", "if 0xbf else 1 endif", ""),
            ScriptTest("0", "if 0xc0 else 1 endif", ""),
            ScriptTest("0", "if 0xc1 else 1 endif", ""),
            ScriptTest("0", "if 0xc2 else 1 endif", ""),
            ScriptTest("0", "if 0xc3 else 1 endif", ""),
            ScriptTest("0", "if 0xc4 else 1 endif", ""),
            ScriptTest("0", "if 0xc5 else 1 endif", ""),
            ScriptTest("0", "if 0xc6 else 1 endif", ""),
            ScriptTest("0", "if 0xc7 else 1 endif", ""),
            ScriptTest("0", "if 0xc8 else 1 endif", ""),
            ScriptTest("0", "if 0xc9 else 1 endif", ""),
            ScriptTest("0", "if 0xca else 1 endif", ""),
            ScriptTest("0", "if 0xcb else 1 endif", ""),
            ScriptTest("0", "if 0xcc else 1 endif", ""),
            ScriptTest("0", "if 0xcd else 1 endif", ""),
            ScriptTest("0", "if 0xce else 1 endif", ""),
            ScriptTest("0", "if 0xcf else 1 endif", ""),
            ScriptTest("0", "if 0xd0 else 1 endif", ""),
            ScriptTest("0", "if 0xd1 else 1 endif", ""),
            ScriptTest("0", "if 0xd2 else 1 endif", ""),
            ScriptTest("0", "if 0xd3 else 1 endif", ""),
            ScriptTest("0", "if 0xd4 else 1 endif", ""),
            ScriptTest("0", "if 0xd5 else 1 endif", ""),
            ScriptTest("0", "if 0xd6 else 1 endif", ""),
            ScriptTest("0", "if 0xd7 else 1 endif", ""),
            ScriptTest("0", "if 0xd8 else 1 endif", ""),
            ScriptTest("0", "if 0xd9 else 1 endif", ""),
            ScriptTest("0", "if 0xda else 1 endif", ""),
            ScriptTest("0", "if 0xdb else 1 endif", ""),
            ScriptTest("0", "if 0xdc else 1 endif", ""),
            ScriptTest("0", "if 0xdd else 1 endif", ""),
            ScriptTest("0", "if 0xde else 1 endif", ""),
            ScriptTest("0", "if 0xdf else 1 endif", ""),
            ScriptTest("0", "if 0xe0 else 1 endif", ""),
            ScriptTest("0", "if 0xe1 else 1 endif", ""),
            ScriptTest("0", "if 0xe2 else 1 endif", ""),
            ScriptTest("0", "if 0xe3 else 1 endif", ""),
            ScriptTest("0", "if 0xe4 else 1 endif", ""),
            ScriptTest("0", "if 0xe5 else 1 endif", ""),
            ScriptTest("0", "if 0xe6 else 1 endif", ""),
            ScriptTest("0", "if 0xe7 else 1 endif", ""),
            ScriptTest("0", "if 0xe8 else 1 endif", ""),
            ScriptTest("0", "if 0xe9 else 1 endif", ""),
            ScriptTest("0", "if 0xea else 1 endif", ""),
            ScriptTest("0", "if 0xeb else 1 endif", ""),
            ScriptTest("0", "if 0xec else 1 endif", ""),
            ScriptTest("0", "if 0xed else 1 endif", ""),
            ScriptTest("0", "if 0xee else 1 endif", ""),
            ScriptTest("0", "if 0xef else 1 endif", ""),
            ScriptTest("0", "if 0xf0 else 1 endif", ""),
            ScriptTest("0", "if 0xf1 else 1 endif", ""),
            ScriptTest("0", "if 0xf2 else 1 endif", ""),
            ScriptTest("0", "if 0xf3 else 1 endif", ""),
            ScriptTest("0", "if 0xf4 else 1 endif", ""),
            ScriptTest("0", "if 0xf5 else 1 endif", ""),
            ScriptTest("0", "if 0xf6 else 1 endif", ""),
            ScriptTest("0", "if 0xf7 else 1 endif", ""),
            ScriptTest("0", "if 0xf8 else 1 endif", ""),
            ScriptTest("0", "if 0xf9 else 1 endif", ""),
            ScriptTest("0", "if 0xfa else 1 endif", ""),
            ScriptTest("0", "if 0xfb else 1 endif", ""),
            ScriptTest("0", "if 0xfc else 1 endif", ""),
            ScriptTest("0", "if 0xfd else 1 endif", ""),
            ScriptTest("0", "if 0xfe else 1 endif", ""),
            ScriptTest("0", "if 0xff else 1 endif", ""),
            ScriptTest("nop", "'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'", "520 byte push"),
            ScriptTest("1", "0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61  0x61", "201 opcodes executed. 0x61 is nop"),
            ScriptTest("1 2 3 4 5 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f", "1 2 3 4 5 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f", "1,000 stack size (0x6f is dup3)"),
            ScriptTest("1 toaltstack 2 toaltstack 3 4 5 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f", "1 2 3 4 5 6 7 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f", "1,000 stack size (altstack cleared between scriptsig/scriptpubkey)"),
            ScriptTest("'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f", "'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f dup2 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61", "max-size (10,000-byte), max-push(520 bytes), max-opcodes(201), max stack size(1,000 items). 0x6f is dup3, 0x61 is nop"),
            ScriptTest("0", "if 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 0x50 endif 1", ">201 opcodes, but reserved (0x50) doesn't count towards opcode limit."),
            ScriptTest("nop", "1", ""),
            ScriptTest("1", "[01] equal", "the following is useful for checking implementations of bn_bn2mpi"),
            ScriptTest("127", "[7f] equal", ""),
            ScriptTest("128", "[8000] equal", "leave room for the sign bit"),
            ScriptTest("32767", "[ff7f] equal", ""),
            ScriptTest("32768", "[008000] equal", ""),
            ScriptTest("8388607", "[ffff7f] equal", ""),
            ScriptTest("8388608", "[00008000] equal", ""),
            ScriptTest("2147483647", "[ffffff7f] equal", ""),
            ScriptTest("2147483648", "[0000008000] equal", ""),
            ScriptTest("549755813887", "[ffffffff7f] equal", ""),
            ScriptTest("549755813888", "[000000008000] equal", ""),
            ScriptTest("9223372036854775807", "[ffffffffffffff7f] equal", ""),
            ScriptTest("-1", "[81] equal", "numbers are little-endian with the msb being a sign bit"),
            ScriptTest("-127", "[ff] equal", ""),
            ScriptTest("-128", "[8080] equal", ""),
            ScriptTest("-32767", "[ffff] equal", ""),
            ScriptTest("-32768", "[008080] equal", ""),
            ScriptTest("-8388607", "[ffffff] equal", ""),
            ScriptTest("-8388608", "[00008080] equal", ""),
            ScriptTest("-2147483647", "[ffffffff] equal", ""),
            ScriptTest("-2147483648", "[0000008080] equal", ""),
            ScriptTest("-4294967295", "[ffffffff80] equal", ""),
            ScriptTest("-549755813887", "[ffffffffff] equal", ""),
            ScriptTest("-549755813888", "[000000008080] equal", ""),
            ScriptTest("-9223372036854775807", "[ffffffffffffffff] equal", ""),
            ScriptTest("2147483647", "add1 2147483648 equal", "we can do math on 4-byte integers, and compare 5-byte ones"),
            ScriptTest("2147483647", "add1 1", ""),
            ScriptTest("-2147483647", "add1 1", ""),
            ScriptTest("1", "[0100] equal not", "not the same byte array..."),
            ScriptTest("1", "[0100] numequal", "... but they are numerically equal"),
            ScriptTest("11", "[1.0b0000] numequal", ""),
            ScriptTest("0", "[80] equal not", ""),
            ScriptTest("0", "[80] numequal", "zero numerically equals negative zero"),
            ScriptTest("0", "[0080] numequal", ""),
            ScriptTest("[000080]", "[00000080] numequal", ""),
            ScriptTest("[100080]", "[10000080] numequal", ""),
            ScriptTest("[100000]", "[10000000] numequal", ""),
            ScriptTest("nop", "nop 1", "the following tests check the if(stack.size() < n) tests in each opcode"),
            ScriptTest("1", "if 1 endif", "they are here to catch copy-and-paste errors"),
            ScriptTest("0", "notif 1 endif", "most of them are duplicated elsewhere,"),
            ScriptTest("1", "verify 1", "but, hey, more is always better, right?"),
            ScriptTest("0", "toaltstack 1", ""),
            ScriptTest("1", "toaltstack fromaltstack", ""),
            ScriptTest("0 0", "drop2 1", ""),
            ScriptTest("0 1", "dup2", ""),
            ScriptTest("0 0 1", "dup3", ""),
            ScriptTest("0 1 0 0", "over2", ""),
            ScriptTest("0 1 0 0 0 0", "rot2", ""),
            ScriptTest("0 1 0 0", "swap2", ""),
            ScriptTest("1", "ifdup", ""),
            ScriptTest("nop", "depth 1", ""),
            ScriptTest("0", "drop 1", ""),
            ScriptTest("1", "dup", ""),
            ScriptTest("0 1", "nip", ""),
            ScriptTest("1 0", "over", ""),
            ScriptTest("1 0 0 0 3", "pick", ""),
            ScriptTest("1 0", "pick", ""),
            ScriptTest("1 0 0 0 3", "roll", ""),
            ScriptTest("1 0", "roll", ""),
            ScriptTest("1 0 0", "rot", ""),
            ScriptTest("1 0", "swap", ""),
            ScriptTest("0 1", "tuck", ""),
            ScriptTest("1", "size", ""),
            ScriptTest("0 0", "equal", ""),
            ScriptTest("0 0", "equalverify 1", ""),
            ScriptTest("0", "add1", ""),
            ScriptTest("2", "sub1", ""),
            ScriptTest("-1", "negate", ""),
            ScriptTest("-1", "abs", ""),
            ScriptTest("0", "not", ""),
            ScriptTest("-1", "nonzero", ""),
            ScriptTest("1 0", "add", ""),
            ScriptTest("1 0", "sub", ""),
            ScriptTest("-1 -1", "booland", ""),
            ScriptTest("-1 0", "boolor", ""),
            ScriptTest("0 0", "numequal", ""),
            ScriptTest("0 0", "numequalverify 1", ""),
            ScriptTest("-1 0", "numnotequal", ""),
            ScriptTest("-1 0", "lessthan", ""),
            ScriptTest("1 0", "greaterthan", ""),
            ScriptTest("0 0", "lessthanorequal", ""),
            ScriptTest("0 0", "greaterthanorequal", ""),
            ScriptTest("-1 0", "min", ""),
            ScriptTest("1 0", "max", ""),
            ScriptTest("-1 -1 0", "within", ""),
            ScriptTest("0", "ripemd160", ""),
            ScriptTest("0", "sha1", ""),
            ScriptTest("0", "sha256", ""),
            ScriptTest("0", "hash160", ""),
            ScriptTest("0", "hash256", ""),
            ScriptTest("nop", "codeseparator 1", ""),
            ScriptTest("nop", "nop1 1", ""),
            ScriptTest("nop", "nop4 1", ""),
            ScriptTest("nop", "nop5 1", ""),
            ScriptTest("nop", "nop6 1", ""),
            ScriptTest("nop", "nop7 1", ""),
            ScriptTest("nop", "nop8 1", ""),
            ScriptTest("nop", "nop9 1", ""),
            ScriptTest("nop", "nop10 1", ""),
            ScriptTest("[42424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242]", "[2.42424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242] equal", "basic push signedness check"),
            ScriptTest("[1.42424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242]", "[2.42424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242424242] equal", "basic pushdata1 signedness check"),
            ScriptTest("0x00", "size 0 equal", "basic op_0 execution")
        ]

        for test in valid_context_free_scripts {
            let (tx, outputScript) = makeTransaction(for: test)
            XCTAssert(tx.isValid)
            XCTAssert(verifyScript(test, tx, outputScript, .noRules, true))
            XCTAssert(verifyScript(test, tx, outputScript, .allRules, true))
        }
    }

    func test_script__context_free__invalid() {
        let invalid_context_free_scripts = [
            ScriptTest("", "depth", "test the test: we should have an empty stack after scriptsig evaluation"),
            ScriptTest("  ", "depth", "and multiple spaces should not change that."),
            ScriptTest("   ", "depth", ""),
            ScriptTest("    ", "depth", ""),
            ScriptTest("", "", ""),
            ScriptTest("", "nop", ""),
            ScriptTest("", "nop depth", ""),
            ScriptTest("nop", "", ""),
            ScriptTest("nop", "depth", ""),
            ScriptTest("nop", "nop", ""),
            ScriptTest("nop", "nop depth", ""),
            ScriptTest("depth", "", ""),

            // Reserved.
            ScriptTest("1", "if 0x50 endif 1", "0x50 is reserved"),

            ScriptTest("0x52", "0x5f add 0x60 equal", "0x51 through 0x60 push 1 through 16 onto stack"),
            ScriptTest("0", "nop", ""),

            // Reserved.
            ScriptTest("1", "if ver else 1 endif", "ver is reserved"),
            ScriptTest("0", "if verif else 1 endif", "verif illegal everywhere (but also reserved?)"),
            ScriptTest("0", "if else 1 else verif endif", "verif illegal everywhere (but also reserved?)"),
            ScriptTest("0", "if vernotif else 1 endif", "vernotif illegal everywhere (but also reserved?)"),
            ScriptTest("0", "if else 1 else vernotif endif", "vernotif illegal everywhere (but also reserved?)"),

            ScriptTest("1 if", "1 endif", "if/endif can't span scriptsig/scriptpubkey"),
            ScriptTest("1 if 0 endif", "1 endif", ""),
            ScriptTest("1 else 0 endif", "1", ""),
            ScriptTest("0 notif", "123", ""),
            ScriptTest("0", "dup if endif", ""),
            ScriptTest("0", "if 1 endif", ""),
            ScriptTest("0", "dup if else endif", ""),
            ScriptTest("0", "if 1 else endif", ""),
            ScriptTest("0", "notif else 1 endif", ""),
            ScriptTest("0 1", "if if 1 else 0 endif endif", ""),
            ScriptTest("0 0", "if if 1 else 0 endif endif", ""),
            ScriptTest("1 0", "if if 1 else 0 endif else if 0 else 1 endif endif", ""),
            ScriptTest("0 1", "if if 1 else 0 endif else if 0 else 1 endif endif", ""),
            ScriptTest("0 0", "notif if 1 else 0 endif endif", ""),
            ScriptTest("0 1", "notif if 1 else 0 endif endif", ""),
            ScriptTest("1 1", "notif if 1 else 0 endif else if 0 else 1 endif endif", ""),
            ScriptTest("0 0", "notif if 1 else 0 endif else if 0 else 1 endif endif", ""),
            ScriptTest("1", "if return else else 1 endif", "multiple elses"),
            ScriptTest("1", "if 1 else else return endif", ""),
            ScriptTest("1", "endif", "malformed if/else/endif sequence"),
            ScriptTest("1", "else endif", ""),
            ScriptTest("1", "endif else", ""),
            ScriptTest("1", "endif else if", ""),
            ScriptTest("1", "if else endif else", ""),
            ScriptTest("1", "if else endif else endif", ""),
            ScriptTest("1", "if endif endif", ""),
            ScriptTest("1", "if else else endif endif", ""),
            ScriptTest("1", "return", ""),
            ScriptTest("1", "dup if return endif", ""),
            ScriptTest("1", "return 'data'", "canonical prunable txout format"),
            ScriptTest("0 if", "return endif 1", "still prunable because if/endif can't span scriptsig/scriptpubkey"),
            ScriptTest("0", "verify 1", ""),
            ScriptTest("1", "verify", ""),
            ScriptTest("1", "verify 0", ""),
            ScriptTest("1 toaltstack", "fromaltstack 1", "alt stack not shared between sig/pubkey"),
            ScriptTest("ifdup", "depth 0 equal", ""),
            ScriptTest("drop", "depth 0 equal", ""),
            ScriptTest("dup", "depth 0 equal", ""),
            ScriptTest("1", "dup 1 add 2 equalverify 0 equal", ""),
            ScriptTest("nop", "nip", ""),
            ScriptTest("nop", "1 nip", ""),
            ScriptTest("nop", "1 0 nip", ""),
            ScriptTest("nop", "over 1", ""),
            ScriptTest("1", "over", ""),
            ScriptTest("0 1", "over depth 3 equalverify", ""),
            ScriptTest("19 20 21", "pick 19 equalverify depth 2 equal", ""),
            ScriptTest("nop", "0 pick", ""),
            ScriptTest("1", "-1 pick", ""),
            ScriptTest("19 20 21", "0 pick 20 equalverify depth 3 equal", ""),
            ScriptTest("19 20 21", "1 pick 21 equalverify depth 3 equal", ""),
            ScriptTest("19 20 21", "2 pick 22 equalverify depth 3 equal", ""),
            ScriptTest("nop", "0 roll", ""),
            ScriptTest("1", "-1 roll", ""),
            ScriptTest("19 20 21", "0 roll 20 equalverify depth 2 equal", ""),
            ScriptTest("19 20 21", "1 roll 21 equalverify depth 2 equal", ""),
            ScriptTest("19 20 21", "2 roll 22 equalverify depth 2 equal", ""),
            ScriptTest("nop", "rot 1", ""),
            ScriptTest("nop", "1 rot 1", ""),
            ScriptTest("nop", "1 2 rot 1", ""),
            ScriptTest("nop", "0 1 2 rot", ""),
            ScriptTest("nop", "swap 1", ""),
            ScriptTest("1", "swap 1", ""),
            ScriptTest("0 1", "swap 1 equalverify", ""),
            ScriptTest("nop", "tuck 1", ""),
            ScriptTest("1", "tuck 1", ""),
            ScriptTest("1 0", "tuck depth 3 equalverify swap drop2", ""),
            ScriptTest("nop", "dup2 1", ""),
            ScriptTest("1", "dup2 1", ""),
            ScriptTest("nop", "dup3 1", ""),
            ScriptTest("1", "dup3 1", ""),
            ScriptTest("1 2", "dup3 1", ""),
            ScriptTest("nop", "over2 1", ""),
            ScriptTest("1", "2 3 over2 1", ""),
            ScriptTest("nop", "swap2 1", ""),
            ScriptTest("1", "2 3 swap2 1", ""),

            // Disabled.
            ScriptTest("'a' 'b'", "cat", "cat disabled"),
            ScriptTest("'a' 'b' 0", "if cat else 1 endif", "cat disabled"),
            ScriptTest("'abc' 1 1", "substr", "substr disabled"),
            ScriptTest("'abc' 1 1 0", "if substr else 1 endif", "substr disabled"),
            ScriptTest("'abc' 2 0", "if left else 1 endif", "left disabled"),
            ScriptTest("'abc' 2 0", "if right else 1 endif", "right disabled"),

            ScriptTest("nop", "size 1", ""),

            // Disabled.
            ScriptTest("'abc'", "if invert else 1 endif", "invert disabled"),
            ScriptTest("1 2 0 if and else 1 endif", "nop", "and disabled"),
            ScriptTest("1 2 0 if or else 1 endif", "nop", "or disabled"),
            ScriptTest("1 2 0 if xor else 1 endif", "nop", "xor disabled"),
            ScriptTest("2 0 if 2mul else 1 endif", "nop", "2mul disabled"),
            ScriptTest("2 0 if 2div else 1 endif", "nop", "2div disabled"),
            ScriptTest("2 2 0 if mul else 1 endif", "nop", "mul disabled"),
            ScriptTest("2 2 0 if div else 1 endif", "nop", "div disabled"),
            ScriptTest("2 2 0 if mod else 1 endif", "nop", "mod disabled"),
            ScriptTest("2 2 0 if lshift else 1 endif", "nop", "lshift disabled"),
            ScriptTest("2 2 0 if rshift else 1 endif", "nop", "rshift disabled"),

            ScriptTest("0 1", "equal", ""),
            ScriptTest("1 1 add", "0 equal", ""),
            ScriptTest("11 1 add 12 sub", "11 equal", ""),
            ScriptTest("2147483648 0 add", "nop", "arithmetic operands must be in range [-2^31...2^31] "),
            ScriptTest("-2147483648 0 add", "nop", "arithmetic operands must be in range [-2^31...2^31] "),
            ScriptTest("2147483647 dup add", "4294967294 numequal", "numequal must be in numeric range"),
            ScriptTest("'abcdef' not", "0 equal", "not is an arithmetic operand"),

            // Disabled.
            ScriptTest("2 dup mul", "4 equal", "mul disabled"),
            ScriptTest("2 dup div", "1 equal", "div disabled"),
            ScriptTest("2 2mul", "4 equal", "2mul disabled"),
            ScriptTest("2 2div", "1 equal", "2div disabled"),
            ScriptTest("7 3 mod", "1 equal", "mod disabled"),
            ScriptTest("2 2 lshift", "8 equal", "lshift disabled"),
            ScriptTest("2 1 rshift", "1 equal", "rshift disabled"),

            ScriptTest("1", "nop1 nop2 nop3 nop4 nop5 nop6 nop7 nop8 nop9 nop10 2 equal", ""),
            ScriptTest("'nop_1_to_10' nop1 nop2 nop3 nop4 nop5 nop6 nop7 nop8 nop9 nop10", "'nop_1_to_11' equal", ""),

            // Reserved.
            ScriptTest("0x50", "1", "opcode 0x50 is reserved"),

            ScriptTest("1", "if 0xba else 1 endif", "opcode 0xba invalid if executed"),
            ScriptTest("1", "if 0xbb else 1 endif", "opcode 0xbb invalid if executed"),
            ScriptTest("1", "if 0xbc else 1 endif", "opcode 0xbc invalid if executed"),
            ScriptTest("1", "if 0xbd else 1 endif", "opcode 0xbd invalid if executed"),
            ScriptTest("1", "if 0xbe else 1 endif", "opcode 0xbe invalid if executed"),
            ScriptTest("1", "if 0xbf else 1 endif", "opcode 0xbf invalid if executed"),
            ScriptTest("1", "if 0xc0 else 1 endif", "opcode 0xc0 invalid if executed"),
            ScriptTest("1", "if 0xc1 else 1 endif", "opcode 0xc1 invalid if executed"),
            ScriptTest("1", "if 0xc2 else 1 endif", "opcode 0xc2 invalid if executed"),
            ScriptTest("1", "if 0xc3 else 1 endif", "opcode 0xc3 invalid if executed"),
            ScriptTest("1", "if 0xc4 else 1 endif", "opcode 0xc4 invalid if executed"),
            ScriptTest("1", "if 0xc5 else 1 endif", "opcode 0xc5 invalid if executed"),
            ScriptTest("1", "if 0xc6 else 1 endif", "opcode 0xc6 invalid if executed"),
            ScriptTest("1", "if 0xc7 else 1 endif", "opcode 0xc7 invalid if executed"),
            ScriptTest("1", "if 0xc8 else 1 endif", "opcode 0xc8 invalid if executed"),
            ScriptTest("1", "if 0xc9 else 1 endif", "opcode 0xc9 invalid if executed"),
            ScriptTest("1", "if 0xca else 1 endif", "opcode 0xca invalid if executed"),
            ScriptTest("1", "if 0xcb else 1 endif", "opcode 0xcb invalid if executed"),
            ScriptTest("1", "if 0xcc else 1 endif", "opcode 0xcc invalid if executed"),
            ScriptTest("1", "if 0xcd else 1 endif", "opcode 0xcd invalid if executed"),
            ScriptTest("1", "if 0xce else 1 endif", "opcode 0xce invalid if executed"),
            ScriptTest("1", "if 0xcf else 1 endif", "opcode 0xcf invalid if executed"),
            ScriptTest("1", "if 0xd0 else 1 endif", "opcode 0xd0 invalid if executed"),
            ScriptTest("1", "if 0xd1 else 1 endif", "opcode 0xd1 invalid if executed"),
            ScriptTest("1", "if 0xd2 else 1 endif", "opcode 0xd2 invalid if executed"),
            ScriptTest("1", "if 0xd3 else 1 endif", "opcode 0xd3 invalid if executed"),
            ScriptTest("1", "if 0xd4 else 1 endif", "opcode 0xd4 invalid if executed"),
            ScriptTest("1", "if 0xd5 else 1 endif", "opcode 0xd5 invalid if executed"),
            ScriptTest("1", "if 0xd6 else 1 endif", "opcode 0xd6 invalid if executed"),
            ScriptTest("1", "if 0xd7 else 1 endif", "opcode 0xd7 invalid if executed"),
            ScriptTest("1", "if 0xd8 else 1 endif", "opcode 0xd8 invalid if executed"),
            ScriptTest("1", "if 0xd9 else 1 endif", "opcode 0xd9 invalid if executed"),
            ScriptTest("1", "if 0xda else 1 endif", "opcode 0xda invalid if executed"),
            ScriptTest("1", "if 0xdb else 1 endif", "opcode 0xdb invalid if executed"),
            ScriptTest("1", "if 0xdc else 1 endif", "opcode 0xdc invalid if executed"),
            ScriptTest("1", "if 0xdd else 1 endif", "opcode 0xdd invalid if executed"),
            ScriptTest("1", "if 0xde else 1 endif", "opcode 0xde invalid if executed"),
            ScriptTest("1", "if 0xdf else 1 endif", "opcode 0xdf invalid if executed"),
            ScriptTest("1", "if 0xe0 else 1 endif", "opcode 0xe0 invalid if executed"),
            ScriptTest("1", "if 0xe1 else 1 endif", "opcode 0xe1 invalid if executed"),
            ScriptTest("1", "if 0xe2 else 1 endif", "opcode 0xe2 invalid if executed"),
            ScriptTest("1", "if 0xe3 else 1 endif", "opcode 0xe3 invalid if executed"),
            ScriptTest("1", "if 0xe4 else 1 endif", "opcode 0xe4 invalid if executed"),
            ScriptTest("1", "if 0xe5 else 1 endif", "opcode 0xe5 invalid if executed"),
            ScriptTest("1", "if 0xe6 else 1 endif", "opcode 0xe6 invalid if executed"),
            ScriptTest("1", "if 0xe7 else 1 endif", "opcode 0xe7 invalid if executed"),
            ScriptTest("1", "if 0xe8 else 1 endif", "opcode 0xe8 invalid if executed"),
            ScriptTest("1", "if 0xe9 else 1 endif", "opcode 0xe9 invalid if executed"),
            ScriptTest("1", "if 0xea else 1 endif", "opcode 0xea invalid if executed"),
            ScriptTest("1", "if 0xeb else 1 endif", "opcode 0xeb invalid if executed"),
            ScriptTest("1", "if 0xec else 1 endif", "opcode 0xec invalid if executed"),
            ScriptTest("1", "if 0xed else 1 endif", "opcode 0xed invalid if executed"),
            ScriptTest("1", "if 0xee else 1 endif", "opcode 0xee invalid if executed"),
            ScriptTest("1", "if 0xef else 1 endif", "opcode 0xef invalid if executed"),
            ScriptTest("1", "if 0xf0 else 1 endif", "opcode 0xf0 invalid if executed"),
            ScriptTest("1", "if 0xf1 else 1 endif", "opcode 0xf1 invalid if executed"),
            ScriptTest("1", "if 0xf2 else 1 endif", "opcode 0xf2 invalid if executed"),
            ScriptTest("1", "if 0xf3 else 1 endif", "opcode 0xf3 invalid if executed"),
            ScriptTest("1", "if 0xf4 else 1 endif", "opcode 0xf4 invalid if executed"),
            ScriptTest("1", "if 0xf5 else 1 endif", "opcode 0xf5 invalid if executed"),
            ScriptTest("1", "if 0xf6 else 1 endif", "opcode 0xf6 invalid if executed"),
            ScriptTest("1", "if 0xf7 else 1 endif", "opcode 0xf7 invalid if executed"),
            ScriptTest("1", "if 0xf8 else 1 endif", "opcode 0xf8 invalid if executed"),
            ScriptTest("1", "if 0xf9 else 1 endif", "opcode 0xf9 invalid if executed"),
            ScriptTest("1", "if 0xfa else 1 endif", "opcode 0xfa invalid if executed"),
            ScriptTest("1", "if 0xfb else 1 endif", "opcode 0xfb invalid if executed"),
            ScriptTest("1", "if 0xfc else 1 endif", "opcode 0xfc invalid if executed"),
            ScriptTest("1", "if 0xfd else 1 endif", "opcode 0xfd invalid if executed"),
            ScriptTest("1", "if 0xfe else 1 endif", "opcode 0xfe invalid if executed"),
            ScriptTest("1", "if 0xff else 1 endif", "opcode 0xff invalid if executed"),
            ScriptTest("1 if 1 else", "0xff endif", "invalid because scriptsig and scriptpubkey are processed separately"),
            ScriptTest("nop", "ripemd160", ""),
            ScriptTest("nop", "sha1", ""),
            ScriptTest("nop", "sha256", ""),
            ScriptTest("nop", "hash160", ""),
            ScriptTest("nop", "hash256", ""),
            ScriptTest("nop", "'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'", ">520 byte push"),
            ScriptTest("0", "if 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' endif 1", ">520 byte push in non-executed if branch"),
            ScriptTest("1", "0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61", ">201 opcodes executed. 0x61 is nop"),
            ScriptTest("0", "if 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 endif 1", ">201 opcodes including non-executed if branch. 0x61 is nop"),
            ScriptTest("1 2 3 4 5 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f", "1 2 3 4 5 6 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f", ">1,000 stack size (0x6f is dup3)"),
            ScriptTest("1 2 3 4 5 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f", "1 toaltstack 2 toaltstack 3 4 5 6 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f", ">1,000 stack+altstack size"),
            ScriptTest("nop", "0 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb' 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f 0x6f dup2 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61 0x61", "10,001-byte scriptpubkey"),
            ScriptTest("nop1", "nop10", ""),

            // Reserved.
            ScriptTest("1", "ver", "op_ver is reserved"),
            ScriptTest("1", "verif", "op_verif is reserved"),
            ScriptTest("1", "vernotif", "op_vernotif is reserved"),
            ScriptTest("1", "reserved", "op_reserved is reserved"),
            ScriptTest("1", "reserved1", "op_reserved1 is reserved"),
            ScriptTest("1", "reserved2", "op_reserved2 is reserved"),

            ScriptTest("1", "0xba", "0xba == op_nop10 + 1"),
            ScriptTest("2147483648", "add1 1", "we cannot do math on 5-byte integers"),
            ScriptTest("2147483648", "negate 1", "we cannot do math on 5-byte integers"),
            ScriptTest("-2147483648", "add1 1", "because we use a sign bit, -2147483648 is also 5 bytes"),
            ScriptTest("2147483647", "add1 sub1 1", "we cannot do math on 5-byte integers, even if the result is 4-bytes"),
            ScriptTest("2147483648", "sub1 1", "we cannot do math on 5-byte integers, even if the result is 4-bytes"),
            ScriptTest("1", "1 endif", "endif without if"),
            ScriptTest("1", "if 1", "if without endif"),
            ScriptTest("1 if 1", "endif", "ifs don't carry over"),
            ScriptTest("nop", "if 1 endif", "the following tests check the if(stack.size() < n) tests in each opcode"),
            ScriptTest("nop", "notif 1 endif", "they are here to catch copy-and-paste errors"),
            ScriptTest("nop", "verify 1", "most of them are duplicated elsewhere,"),
            ScriptTest("nop", "toaltstack 1", "but, hey, more is always better, right?"),
            ScriptTest("1", "fromaltstack", ""),
            ScriptTest("1", "drop2 1", ""),
            ScriptTest("1", "dup2", ""),
            ScriptTest("1 1", "dup3", ""),
            ScriptTest("1 1 1", "over2", ""),
            ScriptTest("1 1 1 1 1", "rot2", ""),
            ScriptTest("1 1 1", "swap2", ""),
            ScriptTest("nop", "ifdup 1", ""),
            ScriptTest("nop", "drop 1", ""),
            ScriptTest("nop", "dup 1", ""),
            ScriptTest("1", "nip", ""),
            ScriptTest("1", "over", ""),
            ScriptTest("1 1 1 3", "pick", ""),
            ScriptTest("0", "pick 1", ""),
            ScriptTest("1 1 1 3", "roll", ""),
            ScriptTest("0", "roll 1", ""),
            ScriptTest("1 1", "rot", ""),
            ScriptTest("1", "swap", ""),
            ScriptTest("1", "tuck", ""),
            ScriptTest("nop", "size 1", ""),
            ScriptTest("1", "equal 1", ""),
            ScriptTest("1", "equalverify 1", ""),
            ScriptTest("nop", "add1 1", ""),
            ScriptTest("nop", "sub1 1", ""),
            ScriptTest("nop", "negate 1", ""),
            ScriptTest("nop", "abs 1", ""),
            ScriptTest("nop", "not 1", ""),
            ScriptTest("nop", "nonzero 1", ""),
            ScriptTest("1", "add", ""),
            ScriptTest("1", "sub", ""),
            ScriptTest("1", "booland", ""),
            ScriptTest("1", "boolor", ""),
            ScriptTest("1", "numequal", ""),
            ScriptTest("1", "numequalverify 1", ""),
            ScriptTest("1", "numnotequal", ""),
            ScriptTest("1", "lessthan", ""),
            ScriptTest("1", "greaterthan", ""),
            ScriptTest("1", "lessthanorequal", ""),
            ScriptTest("1", "greaterthanorequal", ""),
            ScriptTest("1", "min", ""),
            ScriptTest("1", "max", ""),
            ScriptTest("1 1", "within", ""),
            ScriptTest("nop", "ripemd160 1", ""),
            ScriptTest("nop", "sha1 1", ""),
            ScriptTest("nop", "sha256 1", ""),
            ScriptTest("nop", "hash160 1", ""),
            ScriptTest("nop", "hash256 1", ""),
            ScriptTest("0x00", "'00' equal", "basic op_0 execution")
        ]

        for test in invalid_context_free_scripts {
            let (tx, outputScript) = makeTransaction(for: test)
            XCTAssert(tx.isValid)
            XCTAssert(verifyScript(test, tx, outputScript, .noRules, false))
            XCTAssert(verifyScript(test, tx, outputScript, .allRules, false))
        }
    }

    func test_script__checksig__single__uses_one_hash() {
        let transaction = try! "0100000002dc38e9359bd7da3b58386204e186d9408685f427f5e513666db735aa8a6b2169000000006a47304402205d8feeb312478e468d0b514e63e113958d7214fa572acd87079a7f0cc026fc5c02200fa76ea05bf243af6d0f9177f241caf606d01fcfd5e62d6befbca24e569e5c27032102100a1a9ca2c18932d6577c58f225580184d0e08226d41959874ac963e3c1b2feffffffffdc38e9359bd7da3b58386204e186d9408685f427f5e513666db735aa8a6b2169010000006b4830450220087ede38729e6d35e4f515505018e659222031273b7366920f393ee3ab17bc1e022100ca43164b757d1a6d1235f13200d4b5f76dd8fda4ec9fc28546b2df5b1211e8df03210275983913e60093b767e85597ca9397fb2f418e57f998d6afbbc536116085b1cbffffffff0140899500000000001976a914fcc9b36d38cf55d7d5b4ee4dddb6b2c17612f48c88ac00000000" |> dataLiteral |> deserializeTransaction
        let signature = try! "30450220087ede38729e6d35e4f515505018e659222031273b7366920f393ee3ab17bc1e022100ca43164b757d1a6d1235f13200d4b5f76dd8fda4ec9fc28546b2df5b1211e8df" |> dataLiteral |> tagDERSignature |> toECSignature
        let publicKey = try! "0275983913e60093b767e85597ca9397fb2f418e57f998d6afbbc536116085b1cb" |> dataLiteral |> toECPublicKey
        let script = try! "76a91433cef61749d11ba2adf091a5e045678177fe3a6d88ac" |> dataLiteral |> deserializeScript
        XCTAssert(checkSignature(signature, sigHashType: .single, publicKey: publicKey, script: script, transaction: transaction, inputIndex: 1))
    }

    func test_script__checksig__normal__success() {
        let transaction = try! "0100000002dc38e9359bd7da3b58386204e186d9408685f427f5e513666db735aa8a6b2169000000006a47304402205d8feeb312478e468d0b514e63e113958d7214fa572acd87079a7f0cc026fc5c02200fa76ea05bf243af6d0f9177f241caf606d01fcfd5e62d6befbca24e569e5c27032102100a1a9ca2c18932d6577c58f225580184d0e08226d41959874ac963e3c1b2feffffffffdc38e9359bd7da3b58386204e186d9408685f427f5e513666db735aa8a6b2169010000006b4830450220087ede38729e6d35e4f515505018e659222031273b7366920f393ee3ab17bc1e022100ca43164b757d1a6d1235f13200d4b5f76dd8fda4ec9fc28546b2df5b1211e8df03210275983913e60093b767e85597ca9397fb2f418e57f998d6afbbc536116085b1cbffffffff0140899500000000001976a914fcc9b36d38cf55d7d5b4ee4dddb6b2c17612f48c88ac00000000" |> dataLiteral |> deserializeTransaction
        let signature = try! "304402205d8feeb312478e468d0b514e63e113958d7214fa572acd87079a7f0cc026fc5c02200fa76ea05bf243af6d0f9177f241caf606d01fcfd5e62d6befbca24e569e5c27" |> dataLiteral |> tagDERSignature |> toECSignature
        let publicKey = try! "02100a1a9ca2c18932d6577c58f225580184d0e08226d41959874ac963e3c1b2fe" |> dataLiteral |> toECPublicKey
        let script = try! "76a914fcc9b36d38cf55d7d5b4ee4dddb6b2c17612f48c88ac" |> dataLiteral |> deserializeScript
        XCTAssert(checkSignature(signature, sigHashType: .single, publicKey: publicKey, script: script, transaction: transaction, inputIndex: 0))
    }

    func test_script__create_endorsement__single_input_single_output__expected() {
        let transaction = try! "0100000001b3807042c92f449bbf79b33ca59d7dfec7f4cc71096704a9c526dddf496ee0970100000000ffffffff01905f0100000000001976a91418c0bd8d1818f1bf99cb1df2269c645318ef7b7388ac00000000" |> dataLiteral |> deserializeTransaction
        let script = try! "dup hash160 [88350574280395ad2c3e2ee20e322073d94e5e40] equalverify checksig" |> toScript
        let privateKey = try! "ce8f4b713ffdd2658900845251890f30371856be201cd1f5b3d970f793634333" |> tagBitcoinHash |> toData |> toECPrivateKey

        let endorsement = try! createEndorsement(privateKey: privateKey, script: script, transaction: transaction, inputIndex: 0, sigHashType: .all)

        XCTAssert(endorsement® |> toBase16 == "3045022100e428d3cc67a724cb6cfe8634aa299e58f189d9c46c02641e936c40cc16c7e8ed0220083949910fe999c21734a1f33e42fca15fb463ea2e08f0a1bccd952aacaadbb801")
    }

    func test_script__create_endorsement__single_input_no_output__expected() {
        let transaction = try! "0100000001b3807042c92f449bbf79b33ca59d7dfec7f4cc71096704a9c526dddf496ee0970000000000ffffffff0000000000" |> dataLiteral |> deserializeTransaction
        let script = try! "dup hash160 [88350574280395ad2c3e2ee20e322073d94e5e40] equalverify checksig" |> toScript
        let privateKey = try! "ce8f4b713ffdd2658900845251890f30371856be201cd1f5b3d970f793634333" |> tagBitcoinHash |> toData |> toECPrivateKey

        let endorsement = try! createEndorsement(privateKey: privateKey, script: script, transaction: transaction, inputIndex: 0, sigHashType: .all)

        XCTAssert(endorsement® |> toBase16 == "3045022100ba57820be5f0b93a0d5b880fbf2a86f819d959ecc24dc31b6b2d4f6ed286f253022071ccd021d540868ee10ca7634f4d270dfac7aea0d5912cf2b104111ac9bc756b01")
    }

    func test_script__generate_signature_hash__all__expected() {
        let transaction = try! "0100000001b3807042c92f449bbf79b33ca59d7dfec7f4cc71096704a9c526dddf496ee0970000000000ffffffff0000000000" |> dataLiteral |> deserializeTransaction
        let script = try! "dup hash160 [88350574280395ad2c3e2ee20e322073d94e5e40] equalverify checksig" |> toScript
        let hash = generateSignatureHash(transaction: transaction, inputIndex: 0, script: script, sigHashType: .all)
        XCTAssert(hash® |> toBase16 == "f89572635651b2e4f89778350616989183c98d1a721c911324bf9f17a0cf5bf0")
    }

    func testEndorsementSize() {
        XCTAssertNoThrow(try "b34ae13c097ec7a206b515b0cc3ff4b2c2f4e0fce30298604be140cdc7a76b74" |> tagBase16 |> toData |> tagEndorsement)
        XCTAssertThrowsError(try "00112233" |> tagBase16 |> toData |> tagEndorsement)
    }
}
