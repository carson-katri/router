struct Order: Codable, Identifiable {
    let id: Int
    let pizza: Pizza
    
    static let sampleData: [Self] = [
        .init(id: 0, pizza: .margherita),
        .init(id: 1, pizza: .deepDish),
        .init(id: 2, pizza: .hawaiian),
        .init(id: 3, pizza: .pepperoni),
    ]
}
