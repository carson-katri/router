import Runtime

enum RouteDecodingError: Error {
    case missingSubRoute(Any.Type)
    case layoutMismatch
    
    case unsupportedType(Any.Type?)
}

final class RouteDecoder<R: Routes>: Decoder {
    var routeString: [Substring]
    var types: [Any.Type]
    weak var context: RouterContext?
    
    var codingPath: [CodingKey] = []
    var userInfo: [CodingUserInfoKey : Any] = [:]
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key>
    where Key : CodingKey {
        .init(RouteKeyedDecodingContainer(decoder: self))
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        throw RouteDecodingError.unsupportedType(nil)
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        RouteSingleValueDecodingContainer(component: routeString.first,
                                          decoder: self)
    }
    
    init(_ routeString: String, types: [Decodable.Type], context: RouterContext) {
        self.routeString = Array(routeString.split(separator: "/").dropFirst())
        self.types = types
        self.context = context
    }
    
    static func decode(_: R.Type,
                       _ routeString: String,
                       to valueLayout: [Decodable.Type],
                       context: RouterContext) throws -> [Any] {
        let decoder = RouteDecoder(routeString, types: valueLayout, context: context)
        return try valueLayout.map {
            let val = try $0.init(from: decoder)
            if decoder.routeString.count > 0 {
                decoder.routeString.removeFirst()
                decoder.types.removeFirst()
            }
            return val
        }
    }
}

fileprivate extension Substring {
    func toBool() throws -> Bool {
        switch self.lowercased() {
        case "yes", "true", "1":
            return true
        case "no", "false", "0":
            return false
        default:
            throw DecodingError.typeMismatch(
                Bool.self,
                .init(codingPath: [], debugDescription: String(self))
            )
        }
    }
}

struct RouteKeyedDecodingContainer<Key: CodingKey, R: Routes>: KeyedDecodingContainerProtocol {
    var codingPath: [CodingKey] = []
    var allKeys: [Key] = []
    let decoder: RouteDecoder<R>
    
    init(decoder: RouteDecoder<R>) {
        self.decoder = decoder
    }
    
    func decode<T>(failableInit initializer: (String) -> T?) throws -> T {
        if let str = decoder.routeString.first,
           let val = initializer(String(str)) {
            if decoder.routeString.count > 0 {
                decoder.routeString.removeFirst()
                decoder.types.removeFirst()
            } else {
                throw RouteDecodingError.layoutMismatch
            }
            return val
        } else {
            throw DecodingError.typeMismatch(
                T.self,
                .init(codingPath: codingPath, debugDescription: String(decoder.routeString.first ?? ""))
            )
        }
    }
    func decode<T>(withInit initializer: (String) -> T) throws -> T {
        return try decode(failableInit: { initializer($0) })
    }
    
    func contains(_ key: Key) -> Bool {
        true
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        // TODO: Handle sub-Route inside a `Codable` type.
        return decoder.routeString.first == nil
    }
    
    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        if let component = decoder.routeString.first {
            return try component.toBool()
        } else {
            throw DecodingError.typeMismatch(
                type,
                .init(codingPath: codingPath, debugDescription: String(decoder.routeString.first ?? ""))
            )
        }
    }
    
    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        try decode(withInit: String.init)
    }
    
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        try decode(failableInit: Double.init)
    }
    
    func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        try decode(failableInit: Float.init)
    }
    
    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        try decode(failableInit: Int.init)
    }
    
    func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        try decode(failableInit: Int8.init)
    }
    
    func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        try decode(failableInit: Int16.init)
    }
    
    func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        try decode(failableInit: Int32.init)
    }
    
    func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        try decode(failableInit: Int64.init)
    }
    
    func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        try decode(failableInit: UInt.init)
    }
    
    func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        try decode(failableInit: UInt8.init)
    }
    
    func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        try decode(failableInit: UInt16.init)
    }
    
    func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        try decode(failableInit: UInt32.init)
    }
    
    func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        try decode(failableInit: UInt64.init)
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        if type is AnyRoutes.Type {
            for router in decoder.context?.routers ?? [] {
                if let res = router.evaluateAny(decoder.routeString.joined(separator: "/")) as? T {
                    return res
                }
            }
            throw RouteDecodingError.missingSubRoute(type)
        } else {
            return try type.init(from: decoder)
        }
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        throw RouteDecodingError.unsupportedType(type)
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        throw RouteDecodingError.unsupportedType(nil)
    }
    
    func superDecoder() throws -> Decoder {
        throw RouteDecodingError.unsupportedType(nil)
    }
    
    func superDecoder(forKey key: Key) throws -> Decoder {
        throw RouteDecodingError.unsupportedType(nil)
    }
}

struct RouteSingleValueDecodingContainer<R: Routes>: SingleValueDecodingContainer {
    let codingPath: [CodingKey] = []
    let component: Substring?
    let decoder: RouteDecoder<R>
    
    func decode<T>(failableInit initializer: (String) -> T?) throws -> T {
        if let str = component,
           let val = initializer(String(str)) {
            return val
        } else {
            throw DecodingError.typeMismatch(
                T.self,
                .init(codingPath: codingPath, debugDescription: String(component ?? ""))
            )
        }
    }
    func decode<T>(withInit initializer: (String) -> T) throws -> T {
        return try decode(failableInit: { initializer($0) })
    }
    
    func decodeNil() -> Bool {
        if component != nil,
           let type = decoder.types.first {
            if let optionalInfo = try? typeInfo(of: type),
               let innerType = optionalInfo.genericTypes.first,
               innerType is AnyRoutes.Type {  // This is a SubRoute
                if !(decoder.context?.routers.contains(where: { $0.routesType == innerType }) ?? false) {
                    // We don't have a `Router` to handle this...
                    // Its possible the `Router` is nested in a `Route` that isn't being
                    // rendered yet. Try passing `nil`, then deal with it after the next render.
                    decoder.context?.needsSubRouteEvaluation = true
                    return true
                }
            }
        }
        return component == nil
    }
    
    func decode(_ type: Bool.Type) throws -> Bool {
        if let component = component {
            return try component.toBool()
        } else {
            throw DecodingError.typeMismatch(
                type,
                .init(codingPath: codingPath, debugDescription: String(component ?? ""))
            )
        }
    }
    
    func decode(_ type: String.Type) throws -> String {
        try decode(withInit: String.init)
    }
    
    func decode(_ type: Double.Type) throws -> Double {
        try decode(failableInit: Double.init)
    }
    
    func decode(_ type: Float.Type) throws -> Float {
        try decode(failableInit: Float.init)
    }
    
    func decode(_ type: Int.Type) throws -> Int {
        try decode(failableInit: Int.init)
    }
    
    func decode(_ type: Int8.Type) throws -> Int8 {
        try decode(failableInit: Int8.init)
    }
    
    func decode(_ type: Int16.Type) throws -> Int16 {
        try decode(failableInit: Int16.init)
    }
    
    func decode(_ type: Int32.Type) throws -> Int32 {
        try decode(failableInit: Int32.init)
    }
    
    func decode(_ type: Int64.Type) throws -> Int64 {
        try decode(failableInit: Int64.init)
    }
    
    func decode(_ type: UInt.Type) throws -> UInt {
        try decode(failableInit: UInt.init)
    }
    
    func decode(_ type: UInt8.Type) throws -> UInt8 {
        try decode(failableInit: UInt8.init)
    }
    
    func decode(_ type: UInt16.Type) throws -> UInt16 {
        try decode(failableInit: UInt16.init)
    }
    
    func decode(_ type: UInt32.Type) throws -> UInt32 {
        try decode(failableInit: UInt32.init)
    }
    
    func decode(_ type: UInt64.Type) throws -> UInt64 {
        try decode(failableInit: UInt64.init)
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        if type is AnyRoutes.Type {
            for router in decoder.context?.routers ?? [] {
                if let res = router.evaluateAny(decoder.routeString.joined(separator: "/")) as? T {
                    return res
                }
            }
            throw RouteDecodingError.missingSubRoute(type)
        } else {
            return try type.init(from: decoder)
        }
    }
}
