import Runtime
import SwiftUI

public protocol AnyRouter {
    var context: RouterContext { get }
    var routesType: AnyRoutes.Type { get }
    func evaluateAny(_ routeString: String) -> AnyRoutes?
}

/// An index of `Routes`
///
/// - Note: For sub-routes to be properly evaluated, there must be a child `Router` present in the tree.
///
public struct Router<R, Content>: AnyRouter, View where R: Routes, Content: View {
    @EnvironmentObject var parentContext: RouterContext
    
    @StateObject public var context = RouterContext(R.self)
    let content: Content
    
    public let routesType: AnyRoutes.Type = R.self
    
    public var body: some View {
        content
            .environmentObject(context)
            .onAppear {
                if _parentContext.exists {
                    context.parentContext = parentContext
                }
            }
            .onPreferenceChange(RouteListKey.self) { routes in
                context.routes = routes.map(\.route)
                if context.routes.count > 0 && context.activeRoute == nil {
                    if _parentContext.exists,
                       parentContext.needsSubRouteEvaluation {
                        // The parent says we need to be evaluated.
                        context.needsSubRouteEvaluation = false
                        for subRoute in parentContext.nextSubRoutes {
                            if let evaluated = evaluate(subRoute) {
                                context.activateRoute(evaluated)
                                return
                            }
                        }
                    }
                    context.activateRoute(R.defaultRoute)
                }
            }
            .onPreferenceChange(RouterListKey.self) { subRouters in
                context.routers = subRouters.map(\.router)
            }
            .preference(key: RouterListKey.self, value: [.init(self)])
    }
    
    public init(_: R.Type, @ViewBuilder _ content: () -> Content) {
        self.content = content()
    }
    
    public func evaluateAny(_ routeString: String) -> AnyRoutes? {
        self.evaluate(routeString)
    }
    
    public func evaluate(_ routeString: String) -> R? {
        for route in context.routes {
            if let result = route.check(against: routeString) as? R {
                return result
            }
        }
        return nil
    }
}
