import SwiftUI

struct HistoryScreen: View {
    @Environment(\.horizontalSizeClass) var horizantalSizeClass
    @StateObject var viewModel = HistoryScreenViewModel()

    @Binding var path: NavigationPath
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
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
                                        path.append(manga)
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
                .animation(.easeInOut(duration: 0.25), value: viewModel.mangaViewModels)
                .padding(16)
                .frame(minHeight: geometry.size.height)
            }
            .frame(width: geometry.size.width)
            .refreshable {
                await viewModel.getMangaReadStates()
            }
            .task(priority: .userInitiated) {
                await viewModel.getMangaReadStates()
            }
        }
    }
}

#Preview {
    HistoryScreen(path: .constant(NavigationPath()))
}
