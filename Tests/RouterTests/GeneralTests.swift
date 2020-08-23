import XCTest
@testable import Router

final class GeneralTests: XCTestCase {
    func testSwitch() {
        switch appRouter.evaluate("orderDetails/0") {
        case let .orderDetails(id): XCTAssertEqual(id, 0)
        default: XCTAssert(false)
        }
        switch appRouter.evaluate("admin/editUser/JohnDoe/0") {
        case let .admin(route): XCTAssertEqual(route, .editUser(name: "JohnDoe", id: 0))
        default: XCTAssert(false)
        }
    }

    static var allTests = [
        ("testSwitch", testSwitch),
    ]
}
