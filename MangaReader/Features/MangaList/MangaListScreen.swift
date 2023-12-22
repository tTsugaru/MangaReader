import SwiftUI

struct MangaListScreen: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @ObservedObject var viewModel: MangaListViewModel
    @Binding var path: NavigationPath

    var showMangaDetailScreen: ((MangaViewModel) -> Void)?

    @ObservedObject private var mangaStore = MangaStore.shared
    @State private var scrollPosition: String?

    private var columns: [GridItem] {
        let compactGrid = [GridItem(), GridItem()]
        let largeGrid = [GridItem(), GridItem(), GridItem(), GridItem()]
        return horizontalSizeClass == .compact ? compactGrid : largeGrid
    }

    private var columnCount: CGFloat {
        CGFloat(columns.count)
    }

    @ViewBuilder
    private func safeAreaBackground(geometry: GeometryProxy) -> some View {
        #if !os(macOS)
            VStack {
                if !viewModel.isLoading, !viewModel.mangas.isEmpty {
                    BlurView(style: .systemThinMaterial)
                        .frame(width: geometry.size.width, height: geometry.safeAreaInsets.top)
                }
                Spacer()
            }
            .animation(.easeInOut(duration: 0.25), value: !viewModel.isLoading)
            .ignoresSafeArea()
        #endif
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
                                    .onTapGesture {
                                        // Navigation for macOS
                                        showMangaDetailScreen?(manga)
                                        // Navigation for iOS/iPadOS
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
                        .scrollTargetLayout()

                        if viewModel.isLoading {
                            ProgressView()
                        }
                    }
                    .padding(16)
                    .frame(minHeight: geometry.size.height)
                }
                .frame(width: geometry.size.width)
                .scrollIndicators(.hidden)
                .scrollPosition(id: $scrollPosition)
                .overlay(safeAreaBackground(geometry: geometry))
                .background(Color("background", bundle: Bundle.main))
                .task {
                    await viewModel.getAllMangas()
                    
                    guard let scrollPosition = viewModel.scrollPosition else { return }
                    reader.scrollTo(scrollPosition, anchor: .top)
                }
                .onDisappear {
                    guard let scrollPosition else { return }
                    viewModel.scrollPosition = scrollPosition
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
