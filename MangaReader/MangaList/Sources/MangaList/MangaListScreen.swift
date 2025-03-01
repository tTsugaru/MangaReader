import Models
import Styles
import SwiftUI

public struct MangaListScreen: View {

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    @State private var selectedManga: MangaViewModel?

    @StateObject public var viewModel: MangaListViewModel = MangaListViewModel()

    public init() {}

    /// Deciding Columns on sizeClasses
    private var columns: [GridItem] {
        #if os(macOS)
            return Array(repeating: GridItem(), count: 7)
        #else
            let compactGrid = [GridItem(), GridItem()]
            let largeGrid = [GridItem(), GridItem(), GridItem()]
            return horizontalSizeClass == .compact ? compactGrid : largeGrid
        #endif
    }

    private var gridView: some View {
        LazyVGrid(columns: columns, alignment: .center) {
            ForEach(Array(zip(viewModel.mangas.indices, viewModel.mangas)), id: \.1) { index, manga in
                NavigationLink(value: manga) {
                    MangaListView(manga: manga)       
                }
                .buttonStyle(.plain)
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
    public var body: some View {
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
    }
}
