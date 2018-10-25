import XCTest
import Bitcoin
import WolfPipe
import WolfStrings

class TestFormats: XCTestCase {
    func testBase10() {
        XCTAssert(btcDecimalPlaces == 8)
        XCTAssert(mbtcDecimalPlaces == 5)
        XCTAssert(ubtcDecimalPlaces == 2)

        let satoshis: UInt64 = 1012345678
        let satoshisString = "1012345678"
        let btcString = "10.12345678"
        XCTAssert(satoshis |> toBase10 == satoshisString)
        XCTAssert(satoshis |> toBase10WithDecimal(at: btcDecimalPlaces) == btcString)
        XCTAssertNoThrow(try satoshisString |> base10ToAmount == satoshis)
        XCTAssertNoThrow(try btcString |> base10ToAmountWithDecimal(at: btcDecimalPlaces) == satoshis)
        XCTAssertThrowsError(try "Foobar" |> base10ToAmount == satoshis) // Invalid format
        XCTAssertThrowsError(try btcString |> base10ToAmountWithDecimal(at: 1) == satoshis) // incorrect decimal place
    }

    func testBase16() {
        let data = Data(bytes: [0x00, 0x11, 0x22, 0x33, 0x44, 0x55, 0x66, 0x77, 0x88, 0x99, 0xaa, 0xbb, 0xcc, 0xdd, 0xee, 0xff])
        let hexString = "00112233445566778899aabbccddeeff"

        XCTAssert(data |> toBase16 == hexString)
        XCTAssertNoThrow(try hexString |> base16ToData == data)
        XCTAssertThrowsError(try "0123456789abcdefg" |> base16ToData) // Invalid characters
        XCTAssertNoThrow(try hexString |> base16ToData |> toBase16 == hexString)
    }

    func testBase16Hash() {
        let hashData = Data(bytes: [0x18, 0x5f, 0x8d, 0xb3, 0x22, 0x71, 0xfe, 0x25, 0xf5, 0x61, 0xa6, 0xfc, 0x93, 0x8b, 0x2e, 0x26, 0x43, 0x06, 0xec, 0x30, 0x4e, 0xda, 0x51, 0x80, 0x07, 0xd1, 0x76, 0x48, 0x26, 0x38, 0x19, 0x69])
        let hashString = "691938264876d1078051da4e30ec0643262e8b93fca661f525fe7122b38d5f18"
        XCTAssertNoThrow(try hashData |> toHash == hashString)
        XCTAssertNoThrow(try hashString |> hashToData == hashData)
        XCTAssertThrowsError(try Data(bytes: [0x01, 0x02]) |> toHash == hashString) // Wrong length
        XCTAssertThrowsError(try "" |> hashToData == hashData) // Empty string
        XCTAssertThrowsError(try "010203" |> hashToData == hashData) // Wrong length
        XCTAssertThrowsError(try (hashString + "x") |> hashToData == hashData) // Invalid character
    }

    func testBase58() {
        XCTAssert(Character("c").isBase58)
        XCTAssertFalse(Character("?").isBase58)
        XCTAssert("c5LMZEgh".isBase58)
        XCTAssertFalse("F00bar".isBase58)
        XCTAssert("Foobar" |> toUTF8 |> toBase58 == "c5LMZEgh")
        XCTAssertNoThrow(try "c5LMZEgh" |> base58ToData |> fromUTF8 == "Foobar")
        XCTAssertNoThrow(try "" |> base58ToData |> fromUTF8 == "") // Empty string
        XCTAssertThrowsError(try "c5LMZEgh0" |> base58ToData |> fromUTF8 == "Foobar") // Invalid character
    }
}
