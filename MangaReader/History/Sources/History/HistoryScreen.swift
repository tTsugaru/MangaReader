import Models
import Styles
import SwiftData
import SwiftUI

public struct HistoryScreen: View {
    @Environment(\.horizontalSizeClass)
    private var horizantalSizeClass

    @Environment(\.modelContext)
    private var modelContext

    @StateObject private var viewModel = HistoryScreenViewModel()

    @Query private var mangaReadStates: [MangaReadState]

    public init() {
        // no-op
    }

    public var body: some View {
        ScrollView {
            VStack {
                if let error = viewModel.error {
                    Text(error.localizedDescription)
                    Button("Try Again") {
                        Task {
                            await viewModel.fetchMangaViewModels(for: mangaReadStates)
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
                                .accessibilityAddTraits(.isButton)
                                .onTapGesture {
//                                    path.append(manga)
                                }
                                .contextMenu {
                                    Button("Remove from History") {
                                        viewModel.deleteMangaReadStates(for: manga.slug, modelContext: modelContext)
                                    }
                                    .padding(16)
                                }
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                }
            }
            .animation(.easeInOut(duration: 0.25), value: viewModel.isRemoving)
            .padding(16)
        }
        .refreshable {
            await viewModel.fetchMangaViewModels(for: mangaReadStates)
        }
        .task(priority: .userInitiated) {
            await viewModel.fetchMangaViewModels(for: mangaReadStates)
        }
    }
}

#Preview {
    HistoryScreen()
}
