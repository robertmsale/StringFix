import XCTest
@testable import StringFix

final class StringFixTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(StringFix().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
