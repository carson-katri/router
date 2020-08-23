import SwiftUI

public struct RouterLink<R, Label>: View where R: Routes, Label: View {
    @EnvironmentObject var context: RouterContext
    let targetRoute: R
    let label: Label
    
    #if os(macOS)
    let buttonStyle = LinkButtonStyle()
    #elseif os(iOS)
    let buttonStyle = DefaultButtonStyle()
    #endif
    
    public var body: some View {
        Button {
            context.activateRoute(targetRoute)
        } label: {
            label
        }
            .buttonStyle(buttonStyle)
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
