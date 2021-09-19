import XCTest
@testable import StringFix

final class StringFixTests: XCTestCase {
    func testSubscripting() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual("https://github.com/robertmsale/StringFix"[8...], "github.com/robertmsale/StringFix")
        XCTAssertEqual("https://github.com/robertmsale/StringFix"[32...40], "StringFix")
        XCTAssertEqual("https://github.com/robertmsale/StringFix"[...17], "https://github.com")
        XCTAssertEqual("https://github.com/robertmsale/StringFix"[8], "g")
    }
    
    func testOuterBetween() {
        XCTAssertEqual("Here is |some| text".outerBetween("|"), "|some|")
        XCTAssertEqual("Here is some |more/ text".outerBetween("|", "/"), "|more/")
    }
    
    func testBetween() {
        XCTAssertEqual("Big !test! today".between("!"), "test")
        XCTAssertEqual("Here ?is some !more? test".between("!", "?"), "more")
    }
    
    func testCamelize() {
        XCTAssertEqual(" Big test big pass pls".camelize(), "bigTestBigPassPls")
        XCTAssertEqual("B!g t3st b!g p@ss pls".camelize(), "bGT3StBGPSsPls")
        XCTAssertEqual("i-am-a-kebab_and_a_snake".camelize(), "iAmAKebabAndASnake")
    }
    
    func testCollapseWhitespace() {
        XCTAssertEqual("     ayyy    ".collapseWhitespace(), "ayyy")
        XCTAssertEqual("     ayyy lmao \n\n\t    ".collapseWhitespace(), "ayyy lmao")
    }
    
    func testIs() {
        XCTAssert("asdfasdgf".isAlpha())
        XCTAssert(!"1asdfasdgf".isAlpha())
        XCTAssert("asdfasdgf124".isAlphaNumeric())
        XCTAssert(!"!!!!ayyy?????%$@#$^%".isAlphaNumeric())
        XCTAssert(!"123hello".isNumeric())
        XCTAssert("123.456".isNumeric())
        XCTAssert(!"123.456.789".isNumeric())
        XCTAssert("123".isIntegral())
        XCTAssert(!"123.5".isIntegral())
        XCTAssert("  \n\t".isEmpty())
        XCTAssert(!"  \n123\t   ".isEmpty())
    }
    
    func testTrim() {
        XCTAssertEqual("   \n\t Ayyy  ".trimLeft(), "Ayyy  ")
        XCTAssertEqual("   \n\t Ayyy  ".trimRight(), "   \n\t Ayyy")
        XCTAssertEqual("   \n\t Ayyy  ".trim(), "Ayyy")
    }
    
    func testSlugify() {
        XCTAssertEqual("have a good day!".slugify(), "have-a-good-day")
        XCTAssertEqual("you!really%%%Shouldn't Have".slugify(), "you-really-shouldn-t-have")
    }
    
    func testPadding() {
        XCTAssertEqual("derp".padLeft(5, "z"), "zzzzzderp")
        XCTAssertEqual("derp".padRight(5, "z"), "derpzzzzz")
        XCTAssertEqual("derp".pad(5, "z"), "zzzzzderpzzzzz")
    }

    static var allTests = [
        ("Subscripting Test", testSubscripting),
        ("OuterBetween Test", testOuterBetween),
        ("Between Test", testBetween),
        ("Camelize Test", testCamelize),
        ("Collapse Whitespace Test", testCollapseWhitespace),
        ("Is Test", testIs),
        ("Trim Test", testTrim),
        ("Slugify Test", testSlugify),
        ("Padding Test", testPadding),
    ]
}
