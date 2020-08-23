import Runtime

protocol AnyRouteStorage {
    var routesType: Any.Type { get }
    var associatedValues: [Codable.Type] { get }
    var route: Any { get }
    func equals(_ other: AnyRouteStorage) -> Bool
}

enum RouteStorage<R: Routes>: Equatable, AnyRouteStorage {
    case plain(R)
    case dynamic(associatedValues: [Codable.Type], constructor: (Any) -> R?)
    
    var routesType: Any.Type { R.self }
    var associatedValues: [Codable.Type] {
        switch self {
        case .dynamic(let res, _): return res
        default: return []
        }
    }
    var route: Any {
        switch self {
        case let .plain(res):
            return res as Any
        case .dynamic(_, let constructor):
            let constructorInfo = try! functionInfo(of: constructor)
            return constructorInfo.returnType
        }
    }
    func equals(_ other: AnyRouteStorage) -> Bool {
        routesType == other.routesType &&
        route as? R == other.route as? R &&
        associatedValues.elementsEqual(other.associatedValues, by: { $0 == $1 })
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch lhs {
        case let .plain(r1):
            switch rhs {
            case let .plain(r2):
                return r1 == r2
            default: return false
            }
        case let .dynamic(av1, c1):
            switch rhs {
            case let .dynamic(av2, c2):
                if av1.count != av2.count {
                    return false
                } else if av1.elementsEqual(av2, by: { $0 == $1 }) {
                    return true
                } else {
                    let c1Info = try! functionInfo(of: c1)
                    let c2Info = try! functionInfo(of: c2)
                    return c1Info.returnType == c2Info.returnType
                }
            default: return false
            }
        }
    }
}
