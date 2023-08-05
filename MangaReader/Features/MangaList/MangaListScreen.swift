import SwiftUI

struct MangaListScreen: View {
    @StateObject var viewModel = MangaListViewModel()

    #if os(iOS)
        var columns = [GridItem(), GridItem()]
    #elseif os(macOS)
        var columns = [GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0)]
    #endif

    @State var hoveringOverManga: MangaViewModel?

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, alignment: .center, spacing: 16) {
                ForEach(viewModel.mangas, id: \.slug) { manga in
                    ZStack {
                        VStack(spacing: 0) {
                            if let coverImage = manga.image, !viewModel.isLoadingImages {
                                coverImage
                                    .resizable()
                                    .frame(width: 176 * 2, height: 224 * 2)
                                    .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                                    .overlay(
                                        Color.black
                                            .opacity((hoveringOverManga?.slug != manga.slug) && hoveringOverManga != nil ? 0.4 : 0)
                                            .animation(.easeInOut)
                                    )
                                    .scaleEffect(hoveringOverManga?.slug == manga.slug ? 1.1 : 1)
                                    .animation(.interpolatingSpring(stiffness: 999, damping: 19), value: hoveringOverManga?.slug == manga.slug)
                                    .onHover { isHovering in
                                        if isHovering {
                                            hoveringOverManga = manga
                                        } else {
                                            hoveringOverManga = nil
                                        }
                                    }
                            } else {
                                ProgressView()
                                    .progressViewStyle(.circular)
                            }
                        }
                    }
                    .zIndex(hoveringOverManga?.slug == manga.slug ? 1 : -1)
                }
            }
            .padding(64)
        }
        .task {
            await viewModel.getAllMangas()
        }
    }
}

#Preview {
    MangaListScreen()
}
