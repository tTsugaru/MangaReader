import SwiftUI

struct MangaListScreen: View {
    @ObservedObject var viewModel: MangaListViewModel

    #if os(iOS)
        @State var columns = [GridItem(), GridItem()]
    #elseif os(macOS)
        @State var columns = [GridItem(), GridItem(), GridItem(), GridItem()]
    #endif

    @State var hoveringOverManga: MangaViewModel?

    @State var columnCount: CGFloat = 4

    var body: some View {
        GeometryReader { _ in
            ScrollView {
                #if os(macOS)
                    Slider(value: $columnCount, in: 2 ... 10, step: 1)
                        .frame(width: 200)
                #endif

                LazyVGrid(columns: columns, alignment: .center) {
                    ForEach(viewModel.mangas, id: \.slug) { manga in
                        ZStack {
                            VStack {
                                if let coverImage = manga.image, !manga.isLoadingCoverImage {
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
                        .scrollTransition(.animated(.bouncy).threshold(.visible(0.3))) { content, phase in
                            content
                                .opacity(phase.isIdentity ? 1 : 0.2)
                                .scaleEffect(phase.isIdentity ? 1 : 0.85)
                                .blur(radius: phase.isIdentity  ? 0 : 10)
                        }
                    }
                }
                .padding(32)
            }
            .task {
                await viewModel.getAllMangas()
            }
            .onChange(of: columnCount) { _, newColumnCount in
                handleChangeOfColumnCount(newColumnCount: newColumnCount)
            }
        }
    }

    private func handleChangeOfColumnCount(newColumnCount: CGFloat) {
        let newColumnCount = Int(newColumnCount)

        if newColumnCount < columns.count {
            while newColumnCount < columns.count {
                columns.remove(at: 0)
            }
        } else {
            while newColumnCount > columns.count {
                columns.append(GridItem())
            }
        }
    }
}

#Preview {
    MangaListScreen(viewModel: MangaListViewModel())
}
