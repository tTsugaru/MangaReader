import SwiftUI

public struct CustomBackButton: View {
    @Environment(\.dismiss) private var dismiss
    
    public init() {}
    
    public var body: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
        }
    }
}
