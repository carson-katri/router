import Router

struct User: Equatable, Codable {
    let id: Int
    let name: String
}

enum AppRoutes: Routes {
    case orders
    case orderDetails(Int)
    case admin(AdminRoutes?)
    case profile(for: User)
}

enum AdminRoutes: Routes {
    case editUser(name: String, id: Int)
    case newUser
}

let adminRouter = Router(AdminRoutes.self) {
    Route(AdminRoutes.newUser)
    Route(AdminRoutes.editUser)
}

let appRouter = Router(AppRoutes.self) {
    Route(AppRoutes.orders)
    Route(AppRoutes.orderDetails)
    Route(AppRoutes.admin) {
        adminRouter
    }
    Route(AppRoutes.profile)
}
