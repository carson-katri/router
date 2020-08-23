import SwiftUI
import Router

struct OrdersList: View {
    var body: some View {
        NavigationView {
            List(Order.sampleData) { order in
                RouterLink(to: AppRoutes.orderDetails(orderId: order.id, .toppings)) {
                    PizzaListItem(pizza: order.pizza)
                        .padding(.vertical)
                }
            }
        }
    }
}

struct OrdersList_Previews: PreviewProvider {
    static var previews: some View {
        OrdersList()
    }
}
