import SwiftUI

struct MangaListScreen: View {

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var path = NavigationPath()
    @State private var selectedManga: MangaViewModel?

    @ObservedObject var viewModel: MangaListViewModel

    /// Deciding Columns on sizeClasses
    private var columns: [GridItem] {
        let compactGrid = [GridItem(), GridItem()]
        let largeGrid = [GridItem(), GridItem(), GridItem()]
        return horizontalSizeClass == .compact ? compactGrid : largeGrid
    }

    private var gridView: some View {
        LazyVGrid(columns: columns, alignment: .center) {
            ForEach(Array(zip(viewModel.mangas.indices, viewModel.mangas)), id: \.1) { index, manga in
                MangaListView(manga: manga)
                    .id(manga.slug)
                    .onTapGesture { path.append(manga) }
                    .task(priority: .userInitiated) {
                        guard (viewModel.mangas.count - columns.count) == index else { return }
                        await viewModel.loadNextPage()
                    }
            }

            if viewModel.isLoadingNextPage {
                ProgressView()
            }
        }
        .padding(16)
        .scrollTargetLayout()
    }

    @ViewBuilder
    var body: some View {
        NavigationStack(path: $path) {
            ScrollViewReader { reader in
                ScrollView {
                    gridView
                }
                .scrollIndicators(.never)
                .background(Color("background", bundle: Bundle.main))
                .refreshable {
                    await viewModel.getAllMangas()
                }
                .task {
                    guard viewModel.mangas.isEmpty else { return }
                    await viewModel.getAllMangas()
                }
            }
            .navigationDestination(for: MangaViewModel.self) { mangaViewModel in
                MangaDetailScreen(path: $path, mangaSlug: mangaViewModel.slug)
            }
        }
    }
}
