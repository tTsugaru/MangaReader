import SwiftData
import SwiftUI

struct ContentView: View {
    @StateObject var listViewModel = MangaListViewModel()
    @State var defaultSelection = 0
    @State var path = NavigationPath()
    @State private var selectedMangaViewModel: MangaViewModel?

    var body: some View {
        #if os(iOS)
            TabView {
                NavigationStack(path: $path) {
                    MangaListScreen(viewModel: listViewModel, path: $path)
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
                List {
                    NavigationLink {
                        MangaListScreen(viewModel: listViewModel, path: $path) { manga in
                            selectedMangaViewModel = manga
                        }
                    } label: {
                        Label("Mangas", systemImage: "books.vertical")
                    }
                }
            } detail: {
                ZStack {
                    MangaListScreen(viewModel: listViewModel, path: $path, showMangaDetailScreen: { manga in
                        selectedMangaViewModel = manga
                    })
                    .zIndex(0)
                    
                    if let selectedMangaViewModel {
                        MangaDetailScreen(manga: selectedMangaViewModel) {
                            self.selectedMangaViewModel = nil
                        }
                        .zIndex(1)
                        .transition(.move(edge: .trailing))
                        .animation(.easeInOut(duration: 0.25))
                    }
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
