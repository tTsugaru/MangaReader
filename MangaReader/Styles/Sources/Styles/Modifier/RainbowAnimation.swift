import SwiftUI

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
