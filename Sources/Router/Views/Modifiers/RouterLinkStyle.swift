import SwiftUI

public protocol RouterLinkStyle {
    init()
    func makeBody<Label>(label: Label,
                         isActive: Binding<Bool>,
                         action: @escaping () -> Void) -> AnyView where Label: View
}

public struct ButtonRouterLinkStyle: RouterLinkStyle {
    public init() {}
    public func makeBody<Label>(label: Label,
                                isActive: Binding<Bool>,
                                action: @escaping () -> Void) -> AnyView where Label : View {
        AnyView(Button(action: action) { label })
    }
}

public struct LinkButtonRouterLinkStyle: RouterLinkStyle {
    public init() {}
    public func makeBody<Label>(label: Label,
                                isActive: Binding<Bool>,
                                action: @escaping () -> Void) -> AnyView where Label : View {
        #if os(macOS)
        let buttonStyle = LinkButtonStyle()
        #elseif os(iOS)
        let buttonStyle = DefaultButtonStyle()
        #endif
        return AnyView(ButtonRouterLinkStyle()
            .makeBody(label: label, isActive: isActive, action: action)
            .buttonStyle(buttonStyle))
    }
}

public struct NavigationLinkRouterLinkStyle: RouterLinkStyle {
    public init() {}
    public func makeBody<Label>(label: Label,
                                isActive: Binding<Bool>,
                                action: @escaping () -> Void) -> AnyView where Label : View {
        AnyView(NavigationLink(
            destination: Text(""),
            isActive: isActive,
            label: {
                label
            }
        ))
    }
}

struct RouterLinkStyleKey: EnvironmentKey {
    static let defaultValue: RouterLinkStyle = LinkButtonRouterLinkStyle()
}

extension EnvironmentValues {
    var routerLinkStyle: RouterLinkStyle {
        get {
            self[RouterLinkStyleKey.self]
        }
        set {
            self[RouterLinkStyleKey.self] = newValue
        }
    }
}

extension View {
    public func routerLinkStyle<S: RouterLinkStyle>(_ routerLinkStyle: S) -> some View {
        environment(\.routerLinkStyle, routerLinkStyle)
    }
}
