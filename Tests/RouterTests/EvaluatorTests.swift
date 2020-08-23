import XCTest
@testable import Router

final class EvaluatorTests: XCTestCase {
    fileprivate func evaluate(_ assertion: @autoclosure () -> Bool) {
        let app = XCUIApplication()
        app.launch()
        
    }
    
    func testPlain() {
        evaluate(appRouter.evaluate("orders") == .orders)
        XCTAssert(appRouter.evaluate("orders") == .orders)
        XCTAssert(adminRouter.evaluate("newUser") == .newUser)
    }
    
    func testSingleValue() {
        XCTAssert(appRouter.evaluate("orderDetails/0") == .orderDetails(0))
    }
    
    func testMultipleValues() {
        XCTAssert(adminRouter.evaluate("editUser/JohnDoe/0") == .editUser(name: "JohnDoe", id: 0))
    }
    
    func testNestedRouter() {
        XCTAssert(appRouter.evaluate("admin/editUser/JohnDoe/0") == .admin(.editUser(name: "JohnDoe", id: 0)))
    }
    
    func testCodable() {
        XCTAssert(appRouter.evaluate("profile/0/JohnDoe") == .profile(for: User(id: 0, name: "JohnDoe")))
    }

    static var allTests = [
        ("testEvaluate", testPlain),
        ("testSingleValue", testSingleValue),
        ("testMultipleValues", testMultipleValues),
        ("testNestedRouter", testNestedRouter),
    ]
}
