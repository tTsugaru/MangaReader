import SwiftUI

public extension PrimitiveButtonStyle where Self == RainbowButtonStyle {
    static func rainbow(colors : [Color]) -> RainbowButtonStyle {
        RainbowButtonStyle(colors: colors)
    }

    static var rainbow: RainbowButtonStyle {
        RainbowButtonStyle()
    }
}
public extension PrimitiveButtonStyle where Self == MangaButtonStyle {
    static var mangaButtonStyle: MangaButtonStyle {
        MangaButtonStyle()
    }
}
