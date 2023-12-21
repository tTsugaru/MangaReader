import SwiftUI

struct MangaListScreen: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @ObservedObject var viewModel: MangaListViewModel
    @Binding var path: NavigationPath

    var showMangaDetailScreen: ((MangaViewModel) -> Void)?

    @ObservedObject var mangaStore = MangaStore.shared
    @State private var columnCount: CGFloat = 4

    private var columns: [GridItem] {
        let compactGrid = [GridItem(), GridItem()]
        let largeGrid = [GridItem(), GridItem(), GridItem(), GridItem()]
        return horizontalSizeClass == .compact ? compactGrid : largeGrid
    }

    @ViewBuilder
    var body: some View {
        GeometryReader { geometry in
            ScrollViewReader { reader in
                ScrollView {
                    VStack {
                        LazyVGrid(columns: columns, alignment: .center) {
                            ForEach(Array(zip(viewModel.mangas.indices, viewModel.mangas)), id: \.1) { index, manga in
                                MangaListView(viewModel: viewModel, manga: manga)
                                    .id(manga.slug)
                                    .onHover { isHovering in
                                        guard isHovering else { return }
                                        // TODO: Find better solution for state management when view was changed in SplitView
                                        viewModel.oldSelectedManga = manga
                                    }
                                    .onTapGesture {
                                        // Navigation for macOS
                                        showMangaDetailScreen?(manga)

                                        // Navigation for iOS
                                        path.append(manga)
                                    }
                                    .onAppear {
                                        let bufferSize = Int(columnCount)
                                        guard (viewModel.mangas.count - bufferSize) == index else { return }

                                        mangaStore.storeColors()

                                        Task.detached(priority: .userInitiated) {
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
                        
                        if viewModel.isLoading {
                            ProgressView()
                        }
                    }
                    .padding(16)
                    .frame(minHeight: geometry.size.height)
                }
                .frame(width: geometry.size.width)
                .scrollIndicators(.hidden)
                .overlay {
                    #if !os(macOS)
                    VStack {
                        if !viewModel.isLoading && !viewModel.mangas.isEmpty {
                            BlurView(style: .systemThinMaterial)
                                .frame(width: geometry.size.width, height: geometry.safeAreaInsets.top)
                        }
                        Spacer()
                    }
                    .animation(.easeInOut(duration: 0.25), value: !viewModel.isLoading)
                    .ignoresSafeArea()
                    #endif
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
            }
        }
    }

    // TODO: Fix column change by user
    private func handleChangeOfColumnCount(newColumnCount: CGFloat) {
        let newColumnCount = Int(newColumnCount)

        if newColumnCount < columns.count {
            while newColumnCount < columns.count {
//                columns.remove(at: 0)
            }
        } else {
            while newColumnCount > columns.count {
//                columns.append(GridItem())
            }
        }
    }
}

#Preview {
    MangaListScreen(viewModel: MangaListViewModel(), path: .constant(NavigationPath())) { _ in
    }
}
