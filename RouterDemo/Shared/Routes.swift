import Router

enum AppRoutes: Routes {
    static let defaultRoute: Self = .orders(orderId: nil)
    
    case orders(orderId: Int?, OrderRoutes? = nil)
}

enum OrderRoutes: Routes {
    static let defaultRoute: Self = .overview
    
    case overview
    case toppings
}
