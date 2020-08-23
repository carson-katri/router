import Router

enum AppRoutes: Routes {
    static let defaultRoute: Self = .orders
    
    case orders
    case orderDetails(orderId: Int, OrderRoutes?)
}

enum OrderRoutes: Routes {
    static let defaultRoute: Self = .overview
    
    case overview
    case toppings
}
