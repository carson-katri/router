# Router

*Typesafe routing for SwiftUI.*

First, declare your routes in an enum:

```swift
enum AppRoutes: Routes {
  case orders
  case search(query: String, category: SearchCategory) // You can include Codable types
  case orderDetails(orderId: Int, OrderRoutes) // and subroutes
  
  static let defaultRoute = .orders // Set a default Route
}

enum OrderRoutes: Routes {
  case overview
  case bill
  
  static let defaultRoute = .overview
}

enum SearchCategory: Int, Codable {
  case breakfast, lunch, dinner
}
```

Then use the `Router` and `Route` Views to allow for navigation:

```swift
struct ContentView: View {
  var body: some View {
    Router(AppRoutes.self) {
      Route(AppRoutes.orders) { OrdersView() }
      Route(AppRoutes.search) { route in
        if case let .search(query, category) = route { SearchView(query, category) }
      } // Omit any associated values from the Route definition, and access them from the closure.
      Route(AppRoutes.orderDetails) { route in
        if case let .orderDetails(orderId, _) = route { 
          Router(OrderRoutes.self) { // Declare sub-Routers for deeper navigation.
            Route(OrderRoutes.overview) { OrderOverview(orderId) }
            Route(OrderRoutes.bill) { OrderBill(orderId) }
          }
        }
      }
    }
  }
}
```

Then provide `RouterLinks` to navigate to your new `Routes`:

```swift
struct OrdersView: View {
  var body: some View {
    List(DataSource.orders) {
      RouterLink($0.name, destination: AppRoutes.orderDetails(orderId: $0.id, .overview))
    }
  }
}
```

You can also navigate using a `String`:

```swift
struct MyApp: App {
  @Router var navigator
  
  var body: some Scene {
    WindowGroup("MyApp") {
      ContentView()
        .onOpenURL {
          if let path = $0.path {
            navigator.navigate(to: path)
          }
        }
    }
  }
}
```
