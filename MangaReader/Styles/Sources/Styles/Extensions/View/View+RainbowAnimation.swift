import SwiftUI

extension View {
    func rainbowAnimation(colors: [Color]? = nil) -> some View {
        modifier(RainbowAnimation(colors: colors))
    }
}
