import SwiftUI

public struct RainbowButtonStyle: PrimitiveButtonStyle {
    @State var isHoveringOver: Bool = false
    @State var hoverLocation: CGPoint = .zero

    let colors: [Color]?

    init(colors: [Color]? = nil) {
        self.colors = colors
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .bold()
                .rainbowAnimation(colors: self.colors)
                .padding(16)
            Spacer()
        }
        .background(isHoveringOver ? Color.black.opacity(0.5) : Color.black.opacity(0.3))
        .background {
            GeometryReader { geometry in
                if self.isHoveringOver && hoverLocation != .zero {
                    Circle()
                        .offset(x: self.hoverLocation.x - geometry.size.width / 2, y: self.hoverLocation.y - geometry.size.height / 2)
                        .rainbowAnimation(colors: self.colors)
                        .blur(radius: 10)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .contentShape(Rectangle())
        .onContinuousHover { hoverPhase in
            withAnimation(.easeInOut(duration: 0.15)) {
                switch hoverPhase {
                case let .active(hoverLocation):
                    self.hoverLocation = hoverLocation
                    self.isHoveringOver = true
                case .ended:
                    self.isHoveringOver = false
                }
            }
        }
        .onTapGesture {
            configuration.trigger()
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0) // Visual response on iOS/iPadOs cause there is no hover
                .onChanged { _ in
                    isHoveringOver = true
                }
                .onEnded { _ in
                    isHoveringOver = false
                }
        )
    }
}

public struct MangaButtonStyle: PrimitiveButtonStyle {
    @State var isHoveringOver: Bool = false

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .bold()
                .padding(16)
        }
        .background(isHoveringOver ? Color.black.opacity(0.5) : Color.black.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .contentShape(Rectangle())
        .onHover { self.isHoveringOver = $0 }
        .onTapGesture {
            configuration.trigger()
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0) // Visual response on iOS/iPadOS cause there is no hover
                .onChanged { _ in
                    isHoveringOver = true
                }
                .onEnded { _ in
                    isHoveringOver = false
                }
        )
    }
}
