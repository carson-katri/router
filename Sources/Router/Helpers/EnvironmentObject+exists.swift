import SwiftUI
import Runtime

extension EnvironmentObject {
    /// Runtime trick to check if the EnvironmentObject exists in the current context.
    var exists: Bool {
        try! typeInfo(of: Self.self)
            .property(named: "_store")
            .get(from: self) as? ObjectType != nil
    }
}
