//
//  TestMnemonic.swift
//  Bitcoin_Tests
//
//  Created by Wolf McNally on 10/29/18.
//  Copyright © 2018 Blockchain Commons. All rights reserved.
//

import XCTest
import Bitcoin
import WolfPipe
import WolfStrings

class TestMnemonic: XCTestCase {
    func _test(seed: String, passphrase: String = "", language: Language? = nil, mnemonic: String) throws -> Bool {
        let seedData = try seed |> base16Decode
        if let language = language {
            let encodedMnemonic = try seedData |> mnemonicNew(language: language)
            guard encodedMnemonic == mnemonic else {
                return false
            }
        } else {
            guard try seedData |> mnemonicNew == mnemonic else {
                return false
            }
        }
        let decodedSeedData = try mnemonic |> mnemonicToSeed(passphrase: passphrase)
        guard decodedSeedData == seedData else {
            return false
        }
        return true
    }

    func testMnemonicNew() {
        XCTAssertNoThrow(try _test(seed: "baadf00dbaadf00d", language: .en, mnemonic: "rival hurdle address inspire tenant alone"))
        XCTAssertThrowsError(try _test(seed: "baadf00dbaadf00dbaadf00dbaadf00dff", language: .en, mnemonic: "rival hurdle address inspire tenant alone")) // Invalid seed size
        XCTAssertNoThrow(try _test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .en, mnemonic: "rival hurdle address inspire tenant almost turkey safe asset step lab boy"))
        XCTAssertNoThrow(try _test(seed: "7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f", language: .en, mnemonic: "legal winner thank year wave sausage worth useful legal winner thank yellow"))
        XCTAssertNoThrow(try _test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .es, mnemonic: "previo humilde actuar jarabe tabique ahorro tope pulpo anís señal lavar bahía"))
        XCTAssertNoThrow(try _test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .fr, mnemonic: "placard garantir acerbe gratuit soluble affaire théorie ponctuel anguleux salon horrible bateau"))
        XCTAssertNoThrow(try _test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .it, mnemonic: "rizoma lastra affabile lucidato sultano algebra tramonto rupe annuncio sonda mega bavosa"))
        XCTAssertNoThrow(try _test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .ja, mnemonic: "ねんかん すずしい あひる せたけ ほとんど あんまり めいあん のべる いなか ふとる ぜんりゃく えいせい"))
        XCTAssertNoThrow(try _test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .cs, mnemonic: "semeno mudrc babka nasekat uvolnit bazuka vydra skanzen broskev trefit nuget datel"))
        XCTAssertNoThrow(try _test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .ru, mnemonic: "ремарка кривой айсберг лауреат тротуар амнезия фонтан рояль бакалея сухой магазин бунт"))
        XCTAssertNoThrow(try _test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .uk, mnemonic: "сержант ледачий актив люкс фах арена цемент слон бесіда тротуар мандри верба"))
        XCTAssertNoThrow(try _test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .zh_Hans, mnemonic: "博 肉 地 危 惜 多 陪 荒 因 患 伊 基"))
        XCTAssertNoThrow(try _test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .zh_Hant, mnemonic: "博 肉 地 危 惜 多 陪 荒 因 患 伊 基"))
    }

    func testMnemonicToSeedWithPassphrase() {
        XCTAssertNoThrow(try _test(seed: "2e8905819b8723fe2c1d161860e5ee1830318dbf49a83bd451cfb8440c28bd6fa457fe1296106559a3c80937a1c1069be3a3a5bd381ee6260e8d9739fce1f607", passphrase: "TREZOR", mnemonic: "legal winner thank year wave sausage worth useful legal winner thank yellow"))
        XCTAssertNoThrow(try _test(seed: "3e52585ea1275472a82fa0dcd84121e742140f64a302eca7c390832ba428c707a7ebf449267ae592c51f1740259226e31520de39fd8f33e08788fd21221c6f4e", passphrase: "博 肉 地 危 惜 多 陪 荒 因 患 伊 基", mnemonic: "legal winner thank year wave sausage worth useful legal winner thank yellow"))
        XCTAssertNoThrow(try _test(seed: "e72505021b97e15171fe09e996898888579c4196c445d7629762c5b09586e3fb3d68380120b8d8a6ed6f9a73306dab7bf54127f3a610ede2a2d5b4e59916ac73", passphrase: "博 肉 地 危 惜 多 陪 荒 因 患 伊 基", mnemonic: "previo humilde actuar jarabe tabique ahorro tope pulpo anís señal lavar bahía"))
    }
}
