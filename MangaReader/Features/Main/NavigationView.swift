import SwiftData
import SwiftUI

struct NavigationView: View {
    @StateObject var windowObserver = WindowObserver()
    @StateObject var listViewModel = MangaListViewModel()

    @State private var defaultSelection = 0
    @State private var path = NavigationPath()

    @State private var selectedSidebarItem: Int = 0

    // TODO: Find better solution for macOS navigation
    @State private var selectedMangaViewModel: MangaViewModel?
    @State private var selectedChapterListItem: ChapterListItem?

    private var mangaListScreen: some View {
        ZStack {
            MangaListScreen(viewModel: listViewModel, path: $path, showMangaDetailScreen: { manga in
                selectedMangaViewModel = manga
            })
            .zIndex(0)

            if let selectedMangaViewModel {
                MangaDetailScreen(path: $path, mangaSlug: selectedMangaViewModel.slug) { chapterListItem in
                    selectedChapterListItem = chapterListItem
                } dismiss: {
                    self.selectedMangaViewModel = nil
                    selectedChapterListItem = nil
                }
                .zIndex(1)
                .transition(.move(edge: .trailing))
            }

            if let selectedChapterListItem {
                ReaderScreen(chapterId: selectedChapterListItem.id) {
                    self.selectedChapterListItem = nil
                }
                    .zIndex(2)
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: selectedMangaViewModel)
        .animation(.easeInOut(duration: 0.25), value: selectedChapterListItem)
    }

    // TODO: Research to use SplitView on iPhone too                                                                  
    var body: some View {
        #if os(iOS)
            TabView {
                NavigationStack(path: $path) {
                    MangaListScreen(viewModel: listViewModel, path: $path)
                        .navigationDestination(for: MangaViewModel.self) { manga in
                            MangaDetailScreen(path: $path, mangaSlug: manga.slug)
                        }
                        .navigationDestination(for: ChapterListItem.self) { listItem in
                            ReaderScreen(chapterId: listItem.id)
                        }
                }
                .tabItem {
                    Label("Mangas", systemImage: "books.vertical")
                }

                Text("Favorites")
                    .tabItem {
                        Label("Favorites", systemImage: "star")
                    }
            }
            .environmentObject(windowObserver)
        #elseif os(macOS)
            NavigationSplitView {
                List(SidebarItem.allCases, selection: $selectedSidebarItem) { sidebarItem in
                    HStack {
                        sidebarItem.icon
                        Text(sidebarItem.title)
                    }
                    .id(sidebarItem.id)
                }
            } detail: {
                switch SidebarItem(rawValue: selectedSidebarItem)! {
                case .list: mangaListScreen
                case .favorites: Text("Test")
                }
            }
            .task {
                guard let window = NSApplication.shared.windows.first else { return }
                window.delegate = windowObserver
            }
            .environmentObject(windowObserver)
        #endif
    }
}

#Preview {
    NavigationView()
        .preferredColorScheme(.dark)
        .previewDevice("iPad Pro (11-inch)")
}

#Preview {
    NavigationView()
        .preferredColorScheme(.light)
        .previewDevice("Mac")
}
