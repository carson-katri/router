import XCTest
@testable import Router

final class EncoderTests: XCTestCase {
    func testEncodePlain() {
        XCTAssert(AppRoutes.orders == "orders")
        XCTAssert(AdminRoutes.newUser == "newUser")
    }
    
    func testEncodeSingleValue() {
        XCTAssert(AppRoutes.orderDetails(0) == "orderDetails/0")
    }
    
    func testEncodeNil() {
        XCTAssert(AppRoutes.admin(nil) == "admin")
    }
    
    func testEncodeMultipleComponents() {
        XCTAssert(AdminRoutes.editUser(name: "JohnDoe", id: 0) == "editUser/JohnDoe/0")
    }
    
    func testEncodeNestedRoute() {
        XCTAssert(AppRoutes.admin(.editUser(name: "JohnDoe", id: 0)) == "admin/editUser/JohnDoe/0")
    }
    
    func testEncodeCodable() {
        XCTAssert(AppRoutes.profile(for: .init(id: 0, name: "JohnDoe")) == "profile/0/JohnDoe")
    }
    
    func testRouteCodingStrategy() {
        let input = "thisIsATest"
        let output = ["this", "is", "a", "test"]
        let strategies: [(RouteCodingStrategy, String)] = [
            (CamelCaseRouteCodingStrategy(), "thisIsATest"),
            (KebabCaseRouteCodingStrategy(), "this-is-a-test"),
            (PascalCaseRouteCodingStrategy(), "ThisIsATest"),
            (SnakeCaseRouteCodingStrategy(), "this_is_a_test")
        ]
        for (strategy, expectation) in strategies {
            XCTAssert(strategy.convert(input) == expectation)
            XCTAssert(strategy.decode(expectation).map { $0.lowercased() } == output)
        }
    }

    static var allTests = [
        ("testEncodePlain", testEncodePlain),
        ("testEncodeSingleValue", testEncodeSingleValue),
        ("testEncodeNil", testEncodeNil),
        ("testEncodeMultipleComponents", testEncodeMultipleComponents),
        ("testEncodeNestedRoute", testEncodeNestedRoute),
        ("testEncodeCodable", testEncodeCodable),
        ("testRouteCodingStrategy", testRouteCodingStrategy)
    ]
}
