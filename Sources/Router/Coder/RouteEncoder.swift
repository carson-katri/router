final class RouteEncoder: Encoder {
    var codingPath: [CodingKey]
    
    var userInfo: [CodingUserInfoKey : Any]
    
    var components: [String]
    
    init() {
        codingPath = []
        userInfo = [:]
        components = []
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        .init(RouteKeyedEncodingContainer(codingPath: codingPath, encoder: self))
    }
    
    func unkeyedContainer() -> UnkeyedEncodingContainer {
        RouteUnkeyedEncodingContainer(codingPath: codingPath, encoder: self)
    }
    
    func singleValueContainer() -> SingleValueEncodingContainer {
        RouteSingleValueEncodingContainer(codingPath: codingPath, encoder: self)
    }
    
    static func encode(value: Encodable) throws -> [String] {
        let encoder = RouteEncoder()
        try value.encode(to: encoder)
        return encoder.components
    }
    
    static func encode(values: [Encodable]) throws -> [String] {
        let encoder = RouteEncoder()
        try values.forEach { try $0.encode(to: encoder) }
        return encoder.components
    }
}

struct RouteKeyedEncodingContainer<Key>: KeyedEncodingContainerProtocol where Key: CodingKey {
    
    var codingPath: [CodingKey]
    
    var encoder: RouteEncoder
    
    mutating func encodeNil(forKey key: Key) throws {}
    
    mutating func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
        encoder.components.append("\(value)")
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type,
                                             forKey key: Key) -> KeyedEncodingContainer<NestedKey>
    where NestedKey : CodingKey {
        .init(RouteKeyedEncodingContainer<NestedKey>(codingPath: codingPath, encoder: encoder))
    }
    
    mutating func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        RouteUnkeyedEncodingContainer(codingPath: encoder.codingPath, encoder: encoder)
    }
    
    mutating func superEncoder() -> Encoder {
        encoder
    }
    
    mutating func superEncoder(forKey key: Key) -> Encoder {
        encoder
    }
    
}

struct RouteUnkeyedEncodingContainer: UnkeyedEncodingContainer {
    var codingPath: [CodingKey]
    var count: Int = 0
    
    var encoder: RouteEncoder
    
    mutating func encodeNil() throws {}
    
    mutating func encode<T>(_ value: T) throws where T : Encodable {
        encoder.components.append("\(value)")
    }
    
    mutating func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        .init(RouteKeyedEncodingContainer(codingPath: codingPath, encoder: encoder))
    }
    
    mutating func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        Self(codingPath: codingPath, encoder: encoder)
    }
    
    mutating func superEncoder() -> Encoder {
        encoder
    }
}

struct RouteSingleValueEncodingContainer: SingleValueEncodingContainer {
    var codingPath: [CodingKey]
    
    var encoder: RouteEncoder
    
    mutating func encodeNil() throws {}
    
    mutating func encode<T>(_ value: T) throws where T : Encodable {
        encoder.components.append("\(value)")
    }
}
