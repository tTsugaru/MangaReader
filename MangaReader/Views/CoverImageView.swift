import Kingfisher
import SwiftUI

struct CoverImageView: View {
    @State private var isHovering = false

    private var animationSpeed: CGFloat = 0.2

    let imageDownloadURL: URL?
    let mangaName: String

    init(imageDownloadURL: URL?, mangaName: String) {
        self.imageDownloadURL = imageDownloadURL
        self.mangaName = mangaName
    }

    var mangaTitle: some View {
        Text(mangaName)
            .padding([.bottom, .horizontal], 16)
            .transition(.move(edge: .bottom))
            .font(.title.bold())
    }

    var body: some View {
        KFImage(imageDownloadURL)
        #if os(iOS)
            .setProcessor(DownsamplingImageProcessor(size: CGSize(width: 180 * 2, height: 230 * 2)))
        #endif
            .cacheOriginalImage()
            .startLoadingBeforeViewAppear()
            .resizable()
            .aspectRatio(11 / 14, contentMode: .fit)
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
    CoverImageView(imageDownloadURL: URL(string: "https://picsum.photos/200/300")!, mangaName: "MangaName")
}
