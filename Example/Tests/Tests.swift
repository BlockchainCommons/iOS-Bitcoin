import XCTest
import Bitcoin
import WolfPipe
import WolfStrings

class Tests: XCTestCase {
    func testBase58() {
        XCTAssert(Character("c").isBase58)
        XCTAssertFalse(Character("?").isBase58)
        XCTAssert("c5LMZEgh".isBase58)
        XCTAssertFalse("F00bar".isBase58)
        XCTAssert("Foobar" |> toUTF8 |> toBase58 == "c5LMZEgh")
        try! XCTAssertNoThrow("c5LMZEgh" |> base58ToData |> fromUTF8 == "Foobar")
        try! XCTAssertThrowsError("c5LMZEgh0" |> base58ToData |> fromUTF8 == "Invalid")
    }
}
