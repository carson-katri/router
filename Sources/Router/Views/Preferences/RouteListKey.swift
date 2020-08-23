import SwiftUI

final class AnyRouteBox: Equatable {
    let route: AnyRoute
    
    init(_ route: AnyRoute) {
        self.route = route
    }
    
    static func == (lhs: AnyRouteBox, rhs: AnyRouteBox) -> Bool {
        lhs.route.equals(rhs.route)
    }
}

struct RouteListKey: PreferenceKey {
    static let defaultValue = [AnyRouteBox]()
    static func reduce(value: inout [AnyRouteBox], nextValue: () -> [AnyRouteBox]) {
        value += nextValue()
    }
}
