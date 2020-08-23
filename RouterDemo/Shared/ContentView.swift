import SwiftUI
import Router

struct ContentView: View {
    var body: some View {
        Router(AppRoutes.self) {
            Route(AppRoutes.orders) {
                OrdersList()
            }
            Route(AppRoutes.orderDetails, orderContent)
        }
    }
    
    @State private var page = 0
    
    @ViewBuilder
    func orderContent(_ order: AppRoutes) -> some View {
        if case let .orderDetails(id, _) = order,
           let pizza = Order.sampleData.first(where: { $0.id == id })?.pizza {
            Router(OrderRoutes.self) {
                VStack {
                    HStack {
                        RouterLink("Back", to: AppRoutes.orders)
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
