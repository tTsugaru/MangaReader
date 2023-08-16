import SwiftUI

struct MangaListScreen: View {
    @ObservedObject var viewModel: MangaListViewModel

    init(viewModel: MangaListViewModel) {
        self.viewModel = viewModel
    }
    
    #if os(iOS)
        @State private var columns = [GridItem(), GridItem()]
    #elseif os(macOS)
        @State private var columns = [GridItem(), GridItem(), GridItem(), GridItem()]
    #endif

    @State private var hoveringOverManga: MangaViewModel?
    @State private var presentMangaDetail = false

    private var columnCount: CGFloat = 4

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, alignment: .center) {
                    ForEach(Array(zip(viewModel.mangas.indices, viewModel.mangas)), id: \.1) { index, manga in
                        CoverImageView(manga: manga)
                            .onHover { _ in
                                hoveringOverManga = manga
                            }
                            .onAppear {
                                let bufferSize = Int(columnCount)
                                guard (viewModel.mangas.count - bufferSize) == index else { return }
                                Task.detached(priority: .background) {
                                    await viewModel.loadNextPage(with: bufferSize * 10)
                                }
                            }
                            .zIndex(hoveringOverManga?.slug == manga.slug ? 1 : -1)
                            .scrollTransition(.animated(.bouncy).threshold(.visible(0.3))) { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1 : 0.2)
                                    .scaleEffect(phase.isIdentity ? 1 : 0.85)
                                    .blur(radius: phase.isIdentity ? 0 : 10)
                            }
                            .onTapGesture {
                                hoveringOverManga = manga
                                presentMangaDetail = true
                            }
                    }
                }
                .padding(32)
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .navigationDestination(isPresented: $presentMangaDetail, destination: {
                if let selectedManga = hoveringOverManga {
                    MangaDetailScreen(manga: selectedManga)
                }
            })
            .background(Color("background", bundle: Bundle.main))
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
