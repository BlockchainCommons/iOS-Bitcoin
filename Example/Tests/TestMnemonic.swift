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
    func testMnemonic() {
        func test(seed: String, language: Language, expected: String) throws -> Bool {
            return try seed |> fromHex |> mnemonicNew(language: language) == expected
        }
        XCTAssertNoThrow(try test(seed: "baadf00dbaadf00d", language: .en, expected: "rival hurdle address inspire tenant alone"))
        XCTAssertThrowsError(try test(seed: "baadf00dbaadf00dbaadf00dbaadf00dff", language: .en, expected: "rival hurdle address inspire tenant alone")) // Invalid seed size
        XCTAssertNoThrow(try test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .en, expected: "rival hurdle address inspire tenant almost turkey safe asset step lab boy"))
        XCTAssertNoThrow(try test(seed: "7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f", language: .en, expected: "legal winner thank year wave sausage worth useful legal winner thank yellow"))
        XCTAssertNoThrow(try test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .es, expected: "previo humilde actuar jarabe tabique ahorro tope pulpo anís señal lavar bahía"))
        XCTAssertNoThrow(try test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .fr, expected: "placard garantir acerbe gratuit soluble affaire théorie ponctuel anguleux salon horrible bateau"))
        XCTAssertNoThrow(try test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .it, expected: "rizoma lastra affabile lucidato sultano algebra tramonto rupe annuncio sonda mega bavosa"))
        XCTAssertNoThrow(try test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .ja, expected: "ねんかん すずしい あひる せたけ ほとんど あんまり めいあん のべる いなか ふとる ぜんりゃく えいせい"))
        XCTAssertNoThrow(try test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .cs, expected: "semeno mudrc babka nasekat uvolnit bazuka vydra skanzen broskev trefit nuget datel"))
        XCTAssertNoThrow(try test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .ru, expected: "ремарка кривой айсберг лауреат тротуар амнезия фонтан рояль бакалея сухой магазин бунт"))
        XCTAssertNoThrow(try test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .uk, expected: "сержант ледачий актив люкс фах арена цемент слон бесіда тротуар мандри верба"))
        XCTAssertNoThrow(try test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .zh_Hans, expected: "博 肉 地 危 惜 多 陪 荒 因 患 伊 基"))
        XCTAssertNoThrow(try test(seed: "baadf00dbaadf00dbaadf00dbaadf00d", language: .zh_Hant, expected: "博 肉 地 危 惜 多 陪 荒 因 患 伊 基"))
    }
}
