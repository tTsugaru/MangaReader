import SwiftUI

struct MangaListScreen: View {
    @StateObject var viewModel = MangaListViewModel()

    #if os(iOS)
        @State var columns = [GridItem(), GridItem()]
    #elseif os(macOS)
        @State var columns = [GridItem(), GridItem(), GridItem(), GridItem()]
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
            .onChange(of: geometry.size.width) { _, newWidth in
                handleChangeOfWidth(newWidth: newWidth)
            }
            .task {
                await viewModel.getAllMangas()
            }
        }
    }
    
    #warning("Is there a better way then geometry reader? (research)")
    private func handleChangeOfWidth(newWidth: CGFloat) {
        let availableColumnCount = Int(newWidth / ((176 * 2) + 32))
        if availableColumnCount < columns.count {
            while availableColumnCount < columns.count {
                columns.remove(at: 0)
            }
        } else {
            while availableColumnCount > columns.count {
                columns.append(GridItem())
            }
        }
    }
}

#Preview {
    MangaListScreen()
}
