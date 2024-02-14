import SwiftData
import SwiftUI

struct NavigationView: View {
    @StateObject var windowObserver = WindowObserver()
    @StateObject var listViewModel = MangaListViewModel()

    @State private var defaultSelection = 0
    @State private var path = NavigationPath()
    @State private var historyStackPath = NavigationPath()

    @State private var selectedSidebarItem = 0

    #warning("Find better solution for macOS navigation")
    @State private var forceFullyDismiss = false
    @State private var selectedMangaSlug = ""
    @State private var chapterNavigation = ChapterNavigation(chapterId: "", currentChapterImageId: nil)
    
    var historyStack: some View {
        HistoryScreen(path: $historyStackPath)
            .navigationDestination(for: MangaDetailViewModel.self) { manga in
                MangaDetailScreen(path: $historyStackPath, mangaSlug: manga.slug)
            }
            .navigationDestination(for: ChapterNavigation.self) { chapterNavigation in
                ReaderScreen(chapterId: chapterNavigation.chapterId, currentChapterImageId: chapterNavigation.currentChapterImageId)
            }
            .navigationDestination(for: [ChapterListItem].self) { chapterListItems in
                CompactChapterListScreen(path: $historyStackPath, mangaSlug: chapterListItems.first?.mangaSlug ?? "", chapterListItems: chapterListItems)
            }
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
                        .navigationDestination(for: [ChapterListItem].self) { chapterListItems in
                            CompactChapterListScreen(path: $path, mangaSlug: chapterListItems.first?.mangaSlug ?? "", chapterListItems: chapterListItems)
                        }
                }
                .tabItem {
                    Label("Mangas", systemImage: "books.vertical")
                }

                Text("Favorites")
                    .tabItem {
                        Label("Favorites", systemImage: "star")
                    }

                NavigationStack(path: $historyStackPath) {
                    historyStack
                }
                .tabItem {
                    Label("History", systemImage: "clock")
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
                ZStack {
                    Group {
                        switch SidebarItem(rawValue: selectedSidebarItem)! {
                        case .list: 
                            MangaListScreen(viewModel: listViewModel, path: $path, showMangaDetailScreen: { manga in
                                selectedMangaSlug = manga.slug
                            })
                            .onDisappear {
                                selectedMangaSlug = ""
                                chapterNavigation = ChapterNavigation(chapterId: "", currentChapterImageId: nil)
                                forceFullyDismiss = true
                            }
                            
                        case .favorites: Text("Test")
                        case .history:
                            HistoryScreen { mangaSlug in
                                selectedMangaSlug = mangaSlug
                            }
                            .onDisappear {
                                selectedMangaSlug = ""
                                chapterNavigation = ChapterNavigation(chapterId: "", currentChapterImageId: nil)
                                forceFullyDismiss = true
                            }
                        }
                    }
                    .zIndex(-1)
                    
                    if !selectedMangaSlug.isEmpty {
                        MangaDetailScreen(path: $path, mangaSlug: selectedMangaSlug) { chapterNavigation in
                            self.chapterNavigation = chapterNavigation
                        } dismiss: {
                            selectedMangaSlug = ""
                            chapterNavigation = ChapterNavigation(chapterId: "", currentChapterImageId: nil)
                            forceFullyDismiss = false
                        }
                        .zIndex(1)
                        .transition(.move(edge: .trailing))
                    }
                    
                    if !chapterNavigation.chapterId.isEmpty {
                        ReaderScreen(chapterId: chapterNavigation.chapterId, currentChapterImageId: chapterNavigation.currentChapterImageId) {
                            chapterNavigation = ChapterNavigation(chapterId: "", currentChapterImageId: nil)
                            forceFullyDismiss = false
                        }
                        .zIndex(2)
                        .transition(.move(edge: .trailing))
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: selectedMangaSlug)
                .animation(.easeInOut(duration: 0.25), value: chapterNavigation)
                .animation(.none, value: forceFullyDismiss)
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
