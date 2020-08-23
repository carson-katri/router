import SwiftUI

struct ToppingsView : View {
    let pizza: Pizza
    
    var body: some View {
        ForEach(Pizza.Toppings.allToppings.filter { pizza.toppings.contains($0) }) {
            Text($0.description)
                .padding(4)
        }
    }
}
