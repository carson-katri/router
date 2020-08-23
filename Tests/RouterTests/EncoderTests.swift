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

    static var allTests = [
        ("testEncodePlain", testEncodePlain),
        ("testEncodeSingleValue", testEncodeSingleValue),
        ("testEncodeNil", testEncodeNil),
        ("testEncodeMultipleComponents", testEncodeMultipleComponents),
        ("testEncodeNestedRoute", testEncodeNestedRoute),
    ]
}
