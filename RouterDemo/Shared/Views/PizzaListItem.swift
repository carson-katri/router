import SwiftUI

struct PizzaListItem: View {
    let pizza: Pizza
    
    var body: some View {
        HStack {
            Text("🍕")
                .font(.system(size: 32))
            VStack(alignment: .leading, spacing: 4) {
                Text("\(pizza.style.rawValue)")
                    .bold()
                Text(Pizza.Toppings.allToppings
                        .filter { pizza.toppings.contains($0) }
                        .map { String($0.emoji) }
                        .joined(separator: " "))
                    .font(.caption)
            }
        }
    }
}

struct PizzaListItem_Previews: PreviewProvider {
    static var previews: some View {
        PizzaListItem(pizza: .deepDish)
    }
}
