import SwiftUI

public struct CustomBackButton: View {
    @Environment(\.dismiss)
    private var dismiss

    public init() {
        // no-op
    }

    public var body: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image(systemName: "chevron.left")
                .accessibilityLabel("Back Button icon")
        })
    }
}
