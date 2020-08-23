public protocol AnyRoutes {
    static var defaultAnyRoute: AnyRoutes { get }
    func encode() throws -> String
}

/// A typesafe configuration of routes.
///
/// - Note:
///     - Up to 10 associated values are allowed in a route.
///     - All associated values must be `Codable`.
///     - `Collection` types are not allowed as associated values.
///     - Sub-routes must be `Optional` to be properly evaluated.
///
public protocol Routes: AnyRoutes, Equatable, Codable {
    static var defaultRoute: Self { get }
}

extension Routes {
    public static var defaultAnyRoute: AnyRoutes { defaultRoute }
    
    /// Convert the case to a `String` using `RouteEncoder`.
    public func encode() throws -> String {
        let reflection = Mirror(reflecting: self)
        if let route = reflection.children.first,
           let routeName = route.label { // Associated Values
            let associatedValues = Mirror(reflecting: route.value).children
            if associatedValues.count > 0 {
                let codableVals = associatedValues.map({ $0.value as! Encodable })
                return try "\(routeName)/\(RouteEncoder.encode(values: codableVals).joined(separator: "/"))"
            } else {
                let components = try RouteEncoder.encode(value: route.value as! Encodable)
                if components.count > 0 {
                    return "\(routeName)/\(components.joined(separator: "/"))"
                } else {
                    return "\(routeName)"
                }
            }
        } else { // Plain
            return "\(self)"
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        try encode().encode(to: encoder)
    }
    
    public init(from decoder: Decoder) throws {
        fatalError("Routes can only be decoded by a Router (Route.evaluate).")
    }
    
    public static func == (lhs: Self, rhs: String) -> Bool {
        do {
            return try lhs.encode() == rhs
        } catch {
            return false
        }
    }
    
    public static func == (lhs: String, rhs: Self) -> Bool {
        rhs == lhs
    }
}
