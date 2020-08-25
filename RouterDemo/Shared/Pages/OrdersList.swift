import SwiftUI
import Router

struct OrdersList: View {
    var body: some View {
        List(Order.sampleData) { order in
            RouterLink(to: AppRoutes.orders(orderId: order.id, .toppings)) {
                PizzaListItem(pizza: order.pizza)
                    .padding(.vertical)
            }
        }
        .routerLinkStyle(NavigationLinkRouterLinkStyle())
    }
}

struct OrdersList_Previews: PreviewProvider {
    static var previews: some View {
        OrdersList()
    }
}
