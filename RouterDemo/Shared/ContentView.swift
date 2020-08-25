import SwiftUI
import Router

struct ContentView: View {
    var body: some View {
        Router(AppRoutes.self) {
            NavigationView {
                Route(AppRoutes.orders) {
                    OrdersList()
                    orderContent($0)
                }
            }
        }
    }
    
    @State private var page = 0
    
    @ViewBuilder
    func orderContent(_ order: AppRoutes) -> some View {
        if case let .orders(id, _) = order,
           let pizza = Order.sampleData.first(where: { $0.id == id })?.pizza {
            Router(OrderRoutes.self) {
                VStack {
                    HStack {
                        RouterLink("Back", to: AppRoutes.orders(orderId: nil))
                        RouterLink("Overview", to: OrderRoutes.overview)
                        RouterLink("Toppings", to: OrderRoutes.toppings)
                    }
                    Route(OrderRoutes.overview) {
                        PizzaInfo(pizza: pizza)
                    }
                    Route(OrderRoutes.toppings) {
                        List { ToppingsView(pizza: pizza) }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
