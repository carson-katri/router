import SwiftUI
import Combine

public final class RouterContext: ObservableObject {
    @Published var routers: [AnyRouter] = []
    @Published var routes: [AnyRoute] = []
    @Published var activeRoute: ActiveRoute? = nil
    /// A sub-`Router` is likely located inside a `Route`. This means we need to render
    /// the `Route` *before* we have the `Router` to evaluate the subroute. We accomplish this by
    /// first rendering the `Route` with the subroute set to `nil`, and once the sub-`Router` becomes
    /// visible we can evaluate it.
    @Published var needsSubRouteEvaluation: Bool = false
    @Published var nextSubRoutes: [String] = []
    
    weak var parentContext: RouterContext? = nil
    
    let contextType: Any.Type
    
    var subscriptions = [AnyCancellable]()
    
    struct ActiveRoute {
        let `case`: AnyRoutes
        let route: AnyRoute
        let content: AnyView
    }
    
    init(_ contextType: Any.Type) {
        self.contextType = contextType
    }
    
    func isActive(_ route: AnyRoute) -> Binding<Bool> {
        .init { [weak self] in
            self?.activeRoute?.route.equals(route) ?? false
        } set: { _ in }
    }
    
    func isActive<R>(_ route: R) -> Binding<Bool> where R: Routes {
        Binding.init { [weak self] in
            if let r = self?.activeRoute?.case as? R {
                return r == route
            }
            return false
        } set: { [weak self] active in
            if active {
                self?.activateRoute(route)
            }
        }
    }
    
    public func activateRoute<R: Routes>(_ selectedRoute: R) {
        if contextType != R.self {
            // Route is not valid in the current context.
            // Try the parent.
            parentContext?.activateRoute(selectedRoute)
        } else {
            for route in routes {
                if let activeRoute = route.check(against: selectedRoute) {
                    self.activeRoute = .init(case: activeRoute,
                                             route: route,
                                             content: route.anyContent(activeRoute))
                    return
                }
            }
        }
    }
}
