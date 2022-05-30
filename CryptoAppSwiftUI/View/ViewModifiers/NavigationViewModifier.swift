import SwiftUI

struct NavigationTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarHidden(true)
            .navigationBarTitleDisplayMode(.inline)
    }
}

extension View {
    func hideNavigation() -> some View {
        modifier(NavigationTitle())
    }
}
