import Kingfisher
import SwiftUI

@MainActor
struct MangaListView: View {
    private var manga: MangaListViewProtocol

    init(manga: MangaListViewProtocol) {
        self.manga = manga
    }

    @ObservedObject private var mangaStore = MangaStore.shared
    @State private var isHovering = false

    private var animationSpeed: CGFloat = 0.2

    private var mangaTitle: some View {
        Text(manga.title)
            .padding([.bottom, .horizontal], 16)
            .transition(.move(edge: .bottom))
            .font(.title.bold())
    }

    var body: some View {
        KFImage(manga.imageDownloadURL)
            .backgroundDecode()
            .onSuccess { populateMangaColors(imageResult: $0) }
            .cacheOriginalImage()
            .startLoadingBeforeViewAppear()
            .setProcessor(DownsamplingImageProcessor(size: CGSize(width: 180 * 2, height: 230 * 2)))
            .resizable()
            .aspectRatio(11 / 14, contentMode: .fit)
            .overlay {
                #if os(macOS)
                    Color.black
                        .opacity(isHovering ? 0 : 0.3)
                        .animation(.easeInOut)
                #endif
            }
            .animation(.easeInOut(duration: animationSpeed)) { content in
                content
                    .overlay {
                        if isHovering {
                            LinearGradient(colors: [.black.opacity(1), .clear], startPoint: .bottom, endPoint: .center)
                        }
                    }
            }

            .animation(.bouncy(duration: animationSpeed, extraBounce: 0.3)) { content in
                content
                    .scaleEffect(isHovering ? 1.1 : 1)
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
            .onHover { isHovering in
                withAnimation(.easeInOut(duration: animationSpeed)) {
                    self.isHovering = isHovering
                }
            }
            .scrollTransition(.animated(.bouncy).threshold(.visible(0.3))) { content, phase in
                content
                    .opacity(phase.isIdentity ? 1 : 0.2)
                    .scaleEffect(phase.isIdentity ? 1 : 0.85)
                    .blur(radius: phase.isIdentity ? 0 : 10)
            }
    }

    private func populateMangaColors(imageResult: RetrieveImageResult) {
        guard mangaStore.prominentColors[manga.slug]?.isEmpty ?? true else { return }

        Task.detached(priority: .medium) {
            let image = imageResult.image
            let resizedImage = image.resize(width: 50, height: 50)

            guard let image = resizedImage else { return }
            let averageCoverColor = image.avrageColor
            let prominentColors = await image.prominentColors()

            Task { @MainActor in
                mangaStore.prominentColors[manga.slug] = prominentColors
                mangaStore.averageCoverColors[manga.slug] = averageCoverColor
            }
        }
    }
}
