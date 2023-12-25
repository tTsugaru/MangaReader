import SwiftUI

public struct RainbowButtonStyle: PrimitiveButtonStyle {
    let colors: [Color]?
    
    init(colors: [Color]? = nil) {
        self.colors = colors
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .bold()
                .rainbowAnimation(colors: colors)
                .padding(16)
            Spacer()
        }
        .background(Color.black.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .contentShape(Rectangle())
        .onTapGesture {
            configuration.trigger()
        }
    }
}
