import SwiftUI

struct CoverImageView: View {
    @State private var isHovering = false

    private var animationSpeed: CGFloat = 0.2

    let image: Image
    let mangaName: String

    init(image: Image, mangaName: String) {
        self.image = image
        self.mangaName = mangaName
    }

    var mangaTitle: some View {
        Text(mangaName)
            .padding([.bottom, .horizontal], 16)
            .transition(.move(edge: .bottom))
            .font(.title.bold())
    }

    var body: some View {
        image
            .resizable()
        #if os(iOS)
            .scaledToFit()
        #elseif os(macOS)
            .frame(width: 176 * 2, height: 224 * 2)
        #endif

            .overlay {
                Color.black
                    .opacity(isHovering ? 0 : 0.3)
                    .animation(.easeInOut)
            }
            .animation(.easeInOut(duration: animationSpeed)) { content in
                content
                    .overlay {
                        if isHovering {
                            LinearGradient(colors: [.black.opacity(1), .clear], startPoint: .bottom, endPoint: .center)
                        }
                    }
            }
            .overlay {
                VStack {
                    Spacer()
                    if isHovering {
                        mangaTitle
                    }
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
            .animation(.bouncy(duration: animationSpeed, extraBounce: 0.3)) { content in
                content
                    .scaleEffect(isHovering ? 1.1 : 1)
            }
            .onHover { isHovering in
                withAnimation(.easeInOut(duration: animationSpeed)) {
                    self.isHovering = isHovering
                }
            }
    }
}

#Preview {
    CoverImageView(image: Image(systemName: "star"), mangaName: "MangaName")
}
