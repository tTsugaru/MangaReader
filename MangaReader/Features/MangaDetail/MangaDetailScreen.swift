import CoreImage
import Kingfisher
import SwiftUI

@MainActor
struct MangaDetailScreen: View {
    @State private var animate = false
    @ObservedObject var manga: MangaViewModel

    var coverImage: some View {
        KFImage(manga.imageDownloadURL)
            .onSuccess { populateMangaColors($0) }
            .placeholder {
                Color.red
                    .frame(width: 500)
            }
            .resizable()
            .scaledToFit()
            .frame(minWidth: 100, maxWidth: 500)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .shadow(radius: 5)
            .animation(.none, value: manga)
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HStack {
                        coverImage

                        VStack {
                            Text(manga.title)

                            if let titles = manga.mdTitles {
                                Text(titles.joined(separator: " | "))
                            }
                        }

                        Spacer()
                    }
                    .padding(16)

                    Spacer()
                }
                .frame(minHeight: geometry.size.height)
            }
            .background {
                FloatingCloudsView(colors: manga.prominentColors)
            }
            .background {
                manga.avrageCoverColor
                    .ignoresSafeArea()
            }
            .background {
                Color("background", bundle: Bundle.main)
                    .ignoresSafeArea()
            }
            .frame(width: geometry.size.width)
            .navigationTitle(manga.title)
        }
    }

    func populateMangaColors(_ result: RetrieveImageResult) {
        Task.detached(priority: .background) {
            let image = result.image
            let prominentColors = image.prominentColors
            let avrageCoverColor = image.avrageColor

            Task { @MainActor in
                withAnimation(.easeInOut) {
                    manga.prominentColors = prominentColors
                    manga.avrageCoverColor = avrageCoverColor
                }
            }
        }
    }
}
