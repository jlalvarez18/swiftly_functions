import XCTest
@testable import swiftly_functions

class swiftly_functionsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(swiftly_functions().text, "Hello, World!")
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
