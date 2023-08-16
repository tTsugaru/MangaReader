import SwiftUI

struct Cloud: View {
    @StateObject var provider = CloudProvider()
    @State var move = false

    let proxy: GeometryProxy
    let color: Color
    let rotationStart: Double
    let duration: TimeInterval
    let alignment: Alignment

    var body: some View {
        Circle()
            .fill(color)
            .frame(height: proxy.size.height / provider.frameHeightRatio)
            .offset(provider.offset)
            .rotationEffect(.init(degrees: move ? rotationStart : rotationStart + 360))
            .animation(Animation.linear(duration: duration).repeatForever(autoreverses: false), value: move)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .opacity(0.8)
            .onAppear {
                move.toggle()
            }
    }
}

class CloudProvider: ObservableObject {
    let offset: CGSize
    let frameHeightRatio: CGFloat

    init() {
        frameHeightRatio = CGFloat.random(in: 0.7 ..< 1.4)
        offset = CGSize(width: CGFloat.random(in: -150 ..< 150),
                        height: CGFloat.random(in: -150 ..< 150))
    }
}

struct FloatingCloudsView: View {
    let colors: [Color]
    
    init(colors: [Color]) {
        self.colors = colors
    }

    private var frameAlignments: [Alignment] = [
        .center,
        .bottom,
        .bottomLeading,
        .bottomTrailing,
        .topLeading,
        .topTrailing,
        .top,
    ]

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ZStack {
                    ForEach(Array(colors.enumerated()), id: \.offset) { index, color in
                        Cloud(proxy: proxy,
                              color: color,
                              rotationStart: Double.random(in: 100 ... 200),
                              duration: TimeInterval(Int.random(in: 5 ... 10)),
                              alignment: frameAlignments[Int.random(in: 0...frameAlignments.count - 1)])
                    }
                }
                .blur(radius: 60)
            }

            .ignoresSafeArea()
        }
    }
}

#Preview {
    FloatingCloudsView(colors: [.red, .green, .yellow, .blue])
}
