import SwiftData
import SwiftUI

struct CustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
        }
    }
}

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
