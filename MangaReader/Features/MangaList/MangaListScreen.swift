import SwiftUI

struct MangaListScreen: View {
    @StateObject var viewModel = MangaListViewModel()

    #if os(iOS)
        var columns = [GridItem(), GridItem()]
    #elseif os(macOS)
        var columns = [GridItem(), GridItem(), GridItem(), GridItem()]
    #endif

    @State var hoveringOverManga: MangaViewModel?

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center, spacing: 32) {
                    ForEach(viewModel.mangas, id: \.slug) { manga in
                        ZStack {
                            VStack {
                                if let coverImage = manga.image, !viewModel.isLoadingImages {
                                    CoverImageView(image: coverImage, mangaName: manga.title)
                                } else {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                }
                            }
                            .onHover { _ in
                                hoveringOverManga = manga
                            }
                        }
                        .zIndex(hoveringOverManga?.slug == manga.slug ? 1 : -1)
                    }
                }
                .padding(32)
            }
            .task {
                await viewModel.getAllMangas()
            }
        }
    }
}

#Preview {
    MangaListScreen()
}
