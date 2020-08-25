public protocol RouteCodingStrategy {
    init()
    /// Converts the components into a specific case.
    func encode(_ components: [String]) -> String
    /// Converts the `identifier` into its individual components.
    func decode(_ identifier: String) -> [String]
}

extension RouteCodingStrategy {
    func convert(_ identifier: String) -> String {
        // We assume the cases are `camelCase`.
        encode(CamelCaseRouteCodingStrategy().decode(identifier))
    }
}

public struct CamelCaseRouteCodingStrategy: RouteCodingStrategy {
    public init() {}
    public func encode(_ components: [String]) -> String {
        (components.first ?? "") + PascalCaseRouteCodingStrategy().encode(Array(components.dropFirst()))
    }
    public func decode(_ identifier: String) -> [String] {
        decode(identifier, withSeparator: \.isUppercase, keepSeparator: true)
    }
}

public struct KebabCaseRouteCodingStrategy: RouteCodingStrategy {
    public init() {}
    public func encode(_ components: [String]) -> String {
        components.joined(separator: "-").lowercased()
    }
    public func decode(_ identifier: String) -> [String] {
        decode(identifier, withSeparator: "-")
    }
}

public struct PascalCaseRouteCodingStrategy: RouteCodingStrategy {
    public init() {}
    public func encode(_ components: [String]) -> String {
        components.map(\.capitalized).joined(separator: "")
    }
    public func decode(_ identifier: String) -> [String] {
        decode(identifier, withSeparator: \.isUppercase, keepSeparator: true)
    }
}

public struct SnakeCaseRouteCodingStrategy: RouteCodingStrategy {
    public init() {}
    public func encode(_ components: [String]) -> String {
        components.joined(separator: "_").lowercased()
    }
    public func decode(_ identifier: String) -> [String] {
        decode(identifier, withSeparator: "_")
    }
}

fileprivate extension RouteCodingStrategy {
    func decode(_ identifier: String,
                withSeparator isSplit: (Character) -> Bool,
                keepSeparator: Bool = false) -> [String] {
        var components = [String]()
        var tmp: String = "\(identifier.first ?? Character())"
        for char in identifier.dropFirst() {
            if isSplit(char) {
                components.append(tmp)
                tmp = keepSeparator ? "\(char)" : ""
            } else {
                tmp.append(char)
            }
        }
        components.append(tmp)
        return components
    }
    func decode(_ identifier: String,
                withSeparator c: Character,
                keepSeparator: Bool = false) -> [String] {
        self.decode(identifier, withSeparator: { $0 == c }, keepSeparator: keepSeparator)
    }
}
