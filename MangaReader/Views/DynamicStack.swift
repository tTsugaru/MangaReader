import SwiftUI

// TODO: Find better/Cleaner? solution
struct DynamicHStack<Content>: View where Content: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        #if os(iOS)
            VStack {
                content()
            }
        #else
            HStack {
                content()
            }
        #endif
    }
}

struct DynamicVStack: View {
    let content: () -> AnyView

    init(content: @escaping () -> AnyView) {
        self.content = content
    }

    var body: some View {
        #if os(iOS)
            HStack {
                content()
            }
        #else
            VStack {
                content()
            }
        #endif
    }
}
