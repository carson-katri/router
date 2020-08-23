import SwiftUI

final class AnyRouterBox: Equatable {
    let router: AnyRouter
    
    init(_ router: AnyRouter) {
        self.router = router
    }
    
    static func == (lhs: AnyRouterBox, rhs: AnyRouterBox) -> Bool {
        type(of: lhs.router) == type(of: rhs.router)
    }
}

struct RouterListKey: PreferenceKey {
    static let defaultValue = [AnyRouterBox]()
    static func reduce(value: inout [AnyRouterBox], nextValue: () -> [AnyRouterBox]) {
        value += nextValue()
    }
}
