public protocol RouteCodingStrategy {
    init()
    /// Converts the components into a specific case.
    func encode(_ components: [String]) -> String
}

extension RouteCodingStrategy {
    func convert(_ identifier: String) -> String {
        // We assume the cases are `camelCase`.
        var components = [String]()
        var tmp: String = "\(identifier.first ?? Character())"
        for char in identifier.dropFirst() {
            if char.isUppercase {
                components.append(tmp)
                tmp = "\(char)"
            } else {
                tmp.append(char)
            }
        }
        components.append(tmp)
        return encode(components)
    }
}

public struct CamelCaseRouteCodingStrategy: RouteCodingStrategy {
    public init() {}
    public func encode(_ components: [String]) -> String {
        (components.first ?? "") + PascalCaseRouteCodingStrategy().encode(Array(components.dropFirst()))
    }
}

public struct KebabCaseRouteCodingStrategy: RouteCodingStrategy {
    public init() {}
    public func encode(_ components: [String]) -> String {
        components.joined(separator: "-").lowercased()
    }
}

public struct PascalCaseRouteCodingStrategy: RouteCodingStrategy {
    public init() {}
    public func encode(_ components: [String]) -> String {
        components.map(\.capitalized).joined(separator: "")
    }
}

public struct SnakeCaseRouteCodingStrategy: RouteCodingStrategy {
    public init() {}
    public func encode(_ components: [String]) -> String {
        components.joined(separator: "_").lowercased()
    }
}
