import SwiftData
import SwiftUI

struct HistoryScreen: View {
    @Environment(\.horizontalSizeClass) private var horizantalSizeClass
    @Environment(\.modelContext) private var modelContext

    @StateObject var viewModel = HistoryScreenViewModel()

    @Query private var mangaReadStates: [MangaReadState]

    var path: Binding<NavigationPath>?
    var selectedMangaSlug: ((String) -> Void)?

    init(path: Binding<NavigationPath>? = nil, selectedMangaSlug: ((String) -> Void)? = nil) {
        self.path = path
        self.selectedMangaSlug = selectedMangaSlug
    }

    var body: some View {
        GeometryReader { geometry in
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
                                    .onTapGesture {
                                        path?.wrappedValue.append(manga)
                                        selectedMangaSlug?(manga.slug)
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
                .frame(minWidth: geometry.size.width, minHeight: geometry.size.height)
            }
            .frame(width: geometry.size.width)
            .refreshable {
                await viewModel.fetchMangaViewModels(for: mangaReadStates)
            }
            .task(priority: .userInitiated) {
                await viewModel.fetchMangaViewModels(for: mangaReadStates)
            }
        }
    }
}

#Preview {
    HistoryScreen(path: .constant(NavigationPath()))
}
