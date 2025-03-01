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
            .animation(
                Animation.linear(duration: duration).repeatForever(autoreverses: false),
                value: move
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .opacity(0.8)
            .onAppear {
                move.toggle()
            }
    }
}
