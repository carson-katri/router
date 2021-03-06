import SwiftUI

public struct RouterLink<R, Label>: View where R: Routes, Label: View {
    @Environment(\.routerLinkStyle) var style
    @EnvironmentObject var context: RouterContext
    let targetRoute: R
    let label: Label
    
    public var body: some View {
        style.makeBody(label: label, isActive: context.isActive(targetRoute)) {
            context.activateRoute(targetRoute)
        }
    }
    
    public init(to targetRoute: R,
                @ViewBuilder label: () -> Label) {
        self.targetRoute = targetRoute
        self.label = label()
    }
    
    public init(to targetRoute: R,
                label: Label) {
        self.targetRoute = targetRoute
        self.label = label
    }
}


extension RouterLink where Label == Text {
    public init<S>(_ titleKey: S, to targetRoute: R) where S: StringProtocol {
        self.init(to: targetRoute) { Text(titleKey) }
    }
}
