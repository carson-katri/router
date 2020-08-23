import SwiftUI

struct PizzaInfo: View {
    let pizza: Pizza
    
    var body: some View {
        List {
            Text("🍕 \(pizza.style.rawValue) Style")
                .font(.largeTitle)
                .bold()
            Section(header: Text("Toppings")) {
                ToppingsView(pizza: pizza)
            }
        }
    }
}

struct PizzaInfo_Previews: PreviewProvider {
    static var previews: some View {
        PizzaInfo(pizza: .hawaiian)
    }
}
