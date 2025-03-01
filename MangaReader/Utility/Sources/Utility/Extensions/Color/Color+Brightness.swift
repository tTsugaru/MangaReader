import Foundation
import SwiftUI

extension Color {
    enum Brightness {
        case light, medium, dark, transparent

        private enum Threshold {
            static let transparent: CGFloat = 0.1
            static let light: CGFloat = 0.75
            static let dark: CGFloat = 0.3
        }

        init(brightness: CGFloat, alpha: CGFloat) {
            if alpha < Threshold.transparent {
                self = .transparent
            } else if brightness > Threshold.light {
                self = .light
            } else if brightness < Threshold.dark {
                self = .dark
            } else {
                self = .medium
            }
        }
    }

    var brightness: Brightness {
        var b: CGFloat = 0
        var a: CGFloat = 0
        #if os(iOS)
        let color = UIColor(self)
        #elseif os(macOS)
        let color = NSColor(self)
        #endif
        color.getHue(nil, saturation: nil, brightness: &b, alpha: &a)
        return .init(brightness: b, alpha: a)
    }
}
