import SwiftData
import SwiftUI

struct NavigationView: View {
    @StateObject var windowObserver = WindowObserver()
    @StateObject var listViewModel = MangaListViewModel()

    @State private var defaultSelection = 0
    @State private var path = NavigationPath()

    @State private var selectedSidebarItem: Int = 0

    // TODO: Find better solution for macOS navigation
    @State private var selectedMangaSlug: String = ""
    @State private var chapterNavigation: ChapterNavigation = .init(chapterId: "", currentChapterImageId: nil)

    private var mangaListScreen: some View {
        ZStack {
            MangaListScreen(viewModel: listViewModel, path: $path, showMangaDetailScreen: { manga in
                selectedMangaSlug = manga.slug
            })
            .zIndex(0)

            if !selectedMangaSlug.isEmpty {
                MangaDetailScreen(path: $path, mangaSlug: selectedMangaSlug) { chapterNavigation in
                    self.chapterNavigation = chapterNavigation
                } dismiss: {
                    selectedMangaSlug = ""
                    chapterNavigation = ChapterNavigation(chapterId: "", currentChapterImageId: nil)
                }
                .zIndex(1)
                .transition(.move(edge: .trailing))
            }

            if !chapterNavigation.chapterId.isEmpty {
                ReaderScreen(chapterId: chapterNavigation.chapterId, currentChapterImageId: chapterNavigation.currentChapterImageId) {
                    chapterNavigation = ChapterNavigation(chapterId: "", currentChapterImageId: nil)
                }
                .zIndex(2)
                .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: selectedMangaSlug)
        .animation(.easeInOut(duration: 0.25), value: chapterNavigation)
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
                        .navigationDestination(for: ChapterNavigation.self) { chapterNavigation in
                            ReaderScreen(chapterId: chapterNavigation.chapterId, currentChapterImageId: chapterNavigation.currentChapterImageId)
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
