import SwiftData
import SwiftUI

class WindowObserver: NSObject, ObservableObject {
    @Published var windowIsResizing = false
}

#if os(macOS)
extension WindowObserver: NSWindowDelegate {
    
    func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize {
        windowIsResizing = true
        return frameSize
    }
    
    func windowDidResize(_ notification: Notification) {
        windowIsResizing = false
    }
}
#endif

enum SidebarItem: Int, Identifiable, CaseIterable {
    var id: Int { rawValue }

    case list
    case favorites

    var title: String {
        switch self {
        case .list: "List"
        case .favorites: "Favorites"
        }
    }

    var icon: Image {
        switch self {
        case .list:
            Image(systemName: "books.vertical")
        case .favorites:
            Image(systemName: "star")
        }
    }
}

struct ContentView: View {
    @StateObject var windowObserver = WindowObserver()
    
    @StateObject var listViewModel = MangaListViewModel()
    @State var defaultSelection = 0
    @State var path = NavigationPath()

    @State private var selectedSidebarItem: Int = 0
    @State private var selectedMangaViewModel: MangaViewModel?
    @State private var selectedChapterListItem: ChapterListItem?

    var mangaListScreen: some View {
        ZStack {
            MangaListScreen(viewModel: listViewModel, path: $path, showMangaDetailScreen: { manga in
                selectedMangaViewModel = manga
            })
            .zIndex(0)

            if let selectedMangaViewModel {
                MangaDetailScreen(path: $path, mangaSlug: selectedMangaViewModel.slug) {
                    self.selectedMangaViewModel = nil
                }
                .zIndex(1)
                .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: selectedMangaViewModel)
    }

    var body: some View {
        #if os(iOS)
            TabView {
                NavigationStack(path: $path) {
                    MangaListScreen(viewModel: listViewModel, path: $path)
                        .navigationDestination(for: MangaViewModel.self) { manga in
                            MangaDetailScreen(path: $path, mangaSlug: manga.slug)
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
        #else
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
    ContentView()
        .preferredColorScheme(.dark)
        .previewDevice("iPad Pro (11-inch)")
}

#Preview {
    ContentView()
        .preferredColorScheme(.light)
        .previewDevice("Mac")
}
