import Kingfisher
import SwiftUI

extension [String: [Color]]: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8), // convert from String to Data
              let result = try? JSONDecoder().decode([String: [Color]].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self), // data is  Data type
              let result = String(data: data, encoding: .utf8) // coerce NSData to String
        else {
            return "{}" // empty Dictionary resprenseted as String
        }
        return result
    }
}

@MainActor
struct MangaListView: View {
    @AppStorage("username") var username: String = "Anonymous"
    @AppStorage("prominentMangaCoverColors") var prominentColors: [String: [Color]] = [:]

    @State private var isHovering = false
    @State private var fetchColorsTask: Task<Void, Never>?
    @State private var imageResult: RetrieveImageResult?
    private var animationSpeed: CGFloat = 0.2

    @ObservedObject var manga: MangaViewModel

    init(manga: MangaViewModel) {
        self.manga = manga
    }

    private var mangaTitle: some View {
        Text(manga.title)
            .padding([.bottom, .horizontal], 16)
            .transition(.move(edge: .bottom))
            .font(.title.bold())
    }

    var body: some View {
        KFImage(manga.imageDownloadURL)
            .cacheOriginalImage()
            .backgroundDecode()
            .onSuccess { imageResult = $0 }
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
            .onAppear {
                populateMangaColors()
            }
            .onDisappear {
                fetchColorsTask?.cancel()
            }
    }

    func populateMangaColors() {
        guard let image = imageResult?.image, prominentColors[manga.slug]?.isEmpty ?? true else { return }

        fetchColorsTask = Task.detached(priority: .background) {
            let image = image
            let resizedImage = image.resize(width: 50, height: 50)

            guard let image = resizedImage else { return }
            let avrageCoverColor = image.avrageColor

            let innerTask = Task { @MainActor in
                let prominentColors = await image.prominentColors()

                self.prominentColors[manga.slug] = prominentColors

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
