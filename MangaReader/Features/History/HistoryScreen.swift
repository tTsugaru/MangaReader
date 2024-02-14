import SwiftUI

struct HistoryScreen: View {
    @Environment(\.horizontalSizeClass) var horizantalSizeClass
    @StateObject var viewModel = HistoryScreenViewModel()

    var path: Binding<NavigationPath>?
    var selectedMangaSlug: ((String) -> Void)?

    init(path: Binding<NavigationPath>? = nil, selectedMangaSlug: ((String) -> Void)? = nil) {
        self.path = path
        self.selectedMangaSlug = selectedMangaSlug
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .center) {
                    if let error = viewModel.error {
                        Text(error.localizedDescription)
                        Button("Try Again") {
                            Task {
                                await viewModel.getMangaReadStates()
                            }
                        }
                    } else if viewModel.isLoading {
                        Text("Loading History")
                        ProgressView()
                    } else if viewModel.mangaViewModels.isEmpty {
                        Text("Empty... Start Reading MANGAS!")
                    } else {
                        LazyVGrid(columns: horizantalSizeClass == .compact ? [GridItem(), GridItem()] : [GridItem(), GridItem(), GridItem(), GridItem()]) {
                            ForEach(viewModel.mangaViewModels) { manga in
                                MangaListView(manga: manga)
                                    .onTapGesture {
                                        path?.wrappedValue.append(manga)
                                        selectedMangaSlug?(manga.slug)
                                    }
                                    .contextMenu {
                                        Button("Remove from History") {
                                            Task {
                                                await viewModel.removeFromHistory(slug: manga.slug)
                                            }
                                        }
                                        .padding(16)
                                    }
                            }
                        }
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: viewModel.isRemoving)
                .padding(16)
                .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
            }
            .frame(width: geometry.size.width)
            .refreshable {
                await viewModel.getMangaReadStates()
            }
            .task(priority: .userInitiated) {
                if viewModel.mangaViewModels.isEmpty {
                    await viewModel.getMangaReadStates()
                }
            }
        }
    }
}

#Preview {
    HistoryScreen(path: .constant(NavigationPath()))
}
