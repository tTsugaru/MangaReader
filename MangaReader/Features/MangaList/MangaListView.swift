import Kingfisher
import SwiftUI

@MainActor
struct MangaListView: View {
    @State private var isHovering = false
    @State private var fetchColorsTask: Task<(), Never>?
    
    private var animationSpeed: CGFloat = 0.2

    @ObservedObject var manga: MangaViewModel

    init(manga: MangaViewModel) {
        self.manga = manga
    }

    var mangaTitle: some View {
        Text(manga.title)
            .padding([.bottom, .horizontal], 16)
            .transition(.move(edge: .bottom))
            .font(.title.bold())
    }

    var body: some View {
        KFImage(manga.imageDownloadURL)
            .cacheOriginalImage()
            .backgroundDecode()
            .onSuccess { imageResult in
                populateMangaColors(imageResult)
            }
            .startLoadingBeforeViewAppear()
        #if os(iOS)
            .setProcessor(DownsamplingImageProcessor(size: CGSize(width: 180 * 2, height: 230 * 2)))
        #endif
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
            .onDisappear {
                fetchColorsTask?.cancel()
            }
    }
    
    func populateMangaColors(_ result: RetrieveImageResult) {
        guard manga.prominentColors.isEmpty, manga.avrageCoverColor == nil else { return }
        
        fetchColorsTask = Task.detached(priority: .userInitiated) {
            let image = result.image
            let resizedImage = image.resize(width: 50, height: 50)
            
            guard let image = resizedImage else { return }
            let prominentColors = image.prominentColors
            let avrageCoverColor = image.avrageColor
            
            let innerTask = Task { @MainActor in
                withAnimation(.easeInOut) {
                    manga.prominentColors = prominentColors
                    manga.avrageCoverColor = avrageCoverColor
                }
            }
            
            guard Task.isCancelled else { return }
            innerTask.cancel()
        }
    }
}
