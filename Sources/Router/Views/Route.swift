import Runtime
import SwiftUI

protocol AnyRoute {
    func check(against routeString: String) -> AnyRoutes?
    func check(against route: AnyRoutes) -> AnyRoutes?
    var anyContent: (AnyRoutes) -> AnyView { get }
    func equals(_ other: AnyRoute) -> Bool
    var anyStorage: AnyRouteStorage { get }
}

/// A case of `Routes`, used in a `Router`.
public struct Route<R, Content>: AnyRoute, View where R: Routes, Content: View {
    @EnvironmentObject var context: RouterContext
    
    let storage: RouteStorage<R>
    var anyStorage: AnyRouteStorage { storage }
    public let content: (R) -> Content
    public var anyContent: (AnyRoutes) -> AnyView {
        {
            AnyView(content($0 as! R))
        }
    }
    
    public var body: some View {
        Group {
            if context.isActive(self).wrappedValue,
               let routeCase = context.activeRoute?.case as? R {
                content(routeCase)
            } else {
                // Something for the preference modifier to hang on to.
                // This messes with layout on macOS, so we need some other way to accomplish this...
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 0, height: 0)
            }
        }
        .preference(key: RouteListKey.self, value: [.init(self)])
    }
    
    public init(_ plain: R, @ViewBuilder _ content: @escaping (R) -> Content) {
        self.storage = .plain(plain)
        self.content = content
    }
    
    public init(_ plain: R, @ViewBuilder _ content: @escaping () -> Content) {
        self.init(plain) { _ in content() }
    }
    
    public init<AssociatedValues>(_ constructor: @escaping (AssociatedValues) -> R,
                                  @ViewBuilder _ content: @escaping (R) -> Content) {
        let constructorInfo = try! functionInfo(of: constructor)
        
        let arguments = constructorInfo.argumentTypes.map { type -> [Any.Type] in
            let info = try! typeInfo(of: type)
            if case .tuple = info.kind {
                return info.properties.map(\.type)
            } else {
                return [type]
            }
        }.reduce([], +)
        
        precondition(arguments.count <= 10, "Routes must not have more than 10 arguments.")
        precondition(arguments.allSatisfy { $0 is Codable.Type }, "All Route arguments must be `Codable`.")
        
        self.storage = .dynamic(
            associatedValues: arguments as! [Codable.Type],
            constructor: {
                guard let associatedValues = $0 as? AssociatedValues else {
                    return nil
                }
                return constructor(associatedValues)
            }
        )
        self.content = content
    }
    
    public init<AssociatedValues>(_ constructor: @escaping (AssociatedValues) -> R,
                                  @ViewBuilder _ content: @escaping () -> Content) {
        self.init(constructor) { _ in content() }
    }
    
    public func check(against routeString: String) -> AnyRoutes? {
        switch storage {
        case let .plain(plainRoute):
            if plainRoute == routeString { return plainRoute }
        case let .dynamic(associatedValues: arguments,
                          constructor: constructor):
            // Attempt to create an instance of the route from the routeString.
            if let constructed = try? constructor(
                RouteDecoder
                    .decode(R.self, routeString, to: arguments, context: context)
                    .splat()
            ) {
                // Double check; it's possible the route matched only based on the arguments.
                if (try? constructed.encode().split(separator: "/").first ?? nil)
                    == routeString.split(separator: "/").first {
                    if context.needsSubRouteEvaluation {
                        if let subRouteArg = arguments.firstIndex(where: {
                            // FIXME: There must be a more efficient way to check this...
                            try! typeInfo(of: $0).genericTypes.first is AnyRoutes.Type
                        }) {
                            let subRouteString = routeString.split(separator: "/").dropFirst(subRouteArg + 1)
                            context.nextSubRoutes.append(subRouteString.joined(separator: "/"))
                        }
                    }
                    return constructed
                }
            }
        }
        return nil
    }
    
    public func check(against route: AnyRoutes) -> AnyRoutes? {
        try? check(against: route.encode())
    }
    
    func equals(_ other: AnyRoute) -> Bool {
        anyStorage.equals(other.anyStorage)
    }
}

extension Route where Content == EmptyView {
    public init(_ plain: R) {
        self.init(plain) { EmptyView() }
    }
    
    public init<AssociatedValues>(_ constructor: @escaping (AssociatedValues) -> R) {
        self.init(constructor) { EmptyView() }
    }
}
