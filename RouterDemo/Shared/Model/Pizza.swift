struct Pizza: Codable {
    let style: Style
    let toppings: Toppings
    
    static let margherita: Self = .init(style: .newYork, toppings: [.basil])
    static let deepDish: Self = .init(style: .chicago, toppings: [.pepperoni, .meatballs, .bacon])
    static let hawaiian: Self = .init(style: .detroit, toppings: [.bacon, .pineapple])
    static let pepperoni: Self = .init(style: .newYork, toppings: [.pepperoni, .olives])
    
    enum Style: String, Codable {
        case newYork = "NY"
        case detroit = "Detroit"
        case chicago = "Chicago"
    }
    
    struct Toppings: OptionSet, Codable, Identifiable, CustomStringConvertible {
        let rawValue: Int
        var id: Int {
            rawValue
        }
        
        static let pepperoni: Self = .init(rawValue: 1 << 0)
        static let meatballs: Self = .init(rawValue: 1 << 1)
        static let bacon: Self = .init(rawValue: 1 << 2)
        static let mushrooms: Self = .init(rawValue: 1 << 3)
        static let pineapple: Self = .init(rawValue: 1 << 4)
        static let basil: Self = .init(rawValue: 1 << 5)
        static let olives: Self = .init(rawValue: 1 << 6)
        
        var description: String {
            "\(emoji) \(name)"
        }
        
        var name: String {
            switch self {
            case .bacon: return "Bacon"
            case .basil: return "Basil"
            case .meatballs: return "Meatballs"
            case .mushrooms: return "Mushrooms"
            case .olives: return "Olives"
            case .pepperoni: return "Pepperoni"
            case .pineapple: return "Pineapple"
            default: return "Unknown topping"
            }
        }
        
        var emoji: Character {
            switch self {
            case .bacon: return "🥓"
            case .basil: return "🌿"
            case .meatballs: return "🍖"
            case .mushrooms: return "🍄"
            case .olives: return "🍸"
            case .pepperoni: return "🍖"
            case .pineapple: return "🍍"
            default: return " "
            }
        }
        
        static let allToppings: [Self] = [
            .bacon,
            .basil,
            .meatballs,
            .mushrooms,
            .olives,
            .pepperoni,
            .pineapple
        ]
    }
}
