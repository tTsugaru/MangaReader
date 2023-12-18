import SwiftUI

struct MangaListScreen: View {
    @ObservedObject var viewModel: MangaListViewModel
    @Binding var path: NavigationPath
    
    var showMangaDetailScreen: ((MangaViewModel) -> Void)?

    #if os(iOS)
        @State private var columns = [GridItem(), GridItem()]
    #elseif os(macOS)
        @State private var columns = [GridItem(), GridItem(), GridItem(), GridItem()]
    #endif

    @State private var columnCount: CGFloat = 4

    @ViewBuilder
    var body: some View {
        ScrollViewReader { reader in
            ScrollView {
                ZStack {
                    LazyVGrid(columns: columns, alignment: .center) {
                        ForEach(Array(zip(viewModel.mangas.indices, viewModel.mangas)), id: \.1) { index, manga in
                            MangaListView(manga: manga)
                                .id(manga.slug)
                                .onTapGesture {
                                    // Navigation for macOS
                                    if let showMangaDetailScreen {
                                        viewModel.oldSelectedManga = manga
                                        showMangaDetailScreen(manga)
                                    }
                                    
                                    // Navigation for iOS
                                    path.append(manga)
                                }
                                .onAppear {
                                    let bufferSize = Int(columnCount)
                                    guard (viewModel.mangas.count - bufferSize) == index else { return }
                                    Task.detached(priority: .background) {
                                        await viewModel.loadNextPage(with: 50)
                                    }
                                }
                                .scrollTransition(.animated(.bouncy).threshold(.visible(0.3))) { content, phase in
                                    content
                                        .opacity(phase.isIdentity ? 1 : 0.2)
                                        .scaleEffect(phase.isIdentity ? 1 : 0.85)
                                        .blur(radius: phase.isIdentity ? 0 : 10)
                                }
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .scrollIndicators(.hidden)
            .background(Color("background", bundle: Bundle.main))
            .task {
                await viewModel.getAllMangas()
                if let oldSelectedManga = viewModel.oldSelectedManga, !viewModel.isLoading {
                    reader.scrollTo(oldSelectedManga.slug)
                }
            }
            .onChange(of: columnCount) { _, newColumnCount in
                handleChangeOfColumnCount(newColumnCount: newColumnCount)
            }
            // Navigation for iOS
            .navigationDestination(for: MangaViewModel.self) { manga in
                MangaDetailScreen(manga: manga)
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
    MangaListScreen(viewModel: MangaListViewModel(), path: .constant(NavigationPath())) { _ in
        
    }
}
