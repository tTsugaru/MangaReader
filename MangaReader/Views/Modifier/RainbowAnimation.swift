import SwiftUI

extension Color {
    func darker(by percentage: CGFloat = 0.2) -> Color {
        #if os(macOS)
            guard let color = NSColor(self).adjusted(by: -abs(percentage)) else {
                return self
            }
        #else
            guard let color = UIColor(self).adjusted(by: -abs(percentage)) else {
                return self
            }
        #endif

        return Color(color)
    }

    func lighter(by percentage: CGFloat = 0.2) -> Color {
        #if os(macOS)
            guard let color = NSColor(self).adjusted(by: abs(percentage)) else {
                return self
            }
        #else
            guard let color = UIColor(self).adjusted(by: abs(percentage)) else {
                return self
            }
        #endif

        return Color(color)
    }
}

#if os(macOS)
    extension NSColor {
        func adjusted(by percentage: CGFloat) -> NSColor? {
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            var alpha: CGFloat = 0

            getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

            let adjustedBrightness = max(min(brightness + percentage, 1.0), 0.0)
            return NSColor(hue: hue, saturation: saturation, brightness: adjustedBrightness, alpha: alpha)
        }
    }
#else
    extension UIColor {
        func adjusted(by percentage: CGFloat) -> UIColor? {
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            var alpha: CGFloat = 0

            guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
                return nil
            }

            let adjustedBrightness = max(min(brightness + percentage, 1.0), 0.0)
            return UIColor(hue: hue, saturation: saturation, brightness: adjustedBrightness, alpha: alpha)
        }
    }
#endif
struct RainbowAnimation: ViewModifier {
    let colors: [Color]?

    init(colors: [Color]? = nil) {
        self.colors = colors
    }

    @State private var isOn: Bool = false
    private let hueColors = stride(from: 0, to: 1, by: 0.01).map {
        Color(hue: $0, saturation: 1, brightness: 1)
    }

    var duration: Double = 4
    var animation: Animation {
        Animation
            .linear(duration: duration)
            .repeatForever(autoreverses: true)
    }

    func body(content: Content) -> some View {
        var gradient: LinearGradient? = nil

        if let colors, !colors.isEmpty {
            gradient = LinearGradient(gradient: Gradient(colors: colors + colors), startPoint: .leading, endPoint: .trailing)
        } else {
            gradient = LinearGradient(gradient: Gradient(colors: hueColors + hueColors), startPoint: .leading, endPoint: .trailing)
        }

        return content
            .overlay {
                GeometryReader { proxy in
                    ZStack {
                        gradient
                            .frame(width: proxy.size.width * 2)
                            .offset(x: isOn ? 0 : -proxy.size.width)
                    }
                }
            }
            .onAppear {
                withAnimation(animation) {
                    isOn = true
                }
            }
            .mask(content)
    }
}
