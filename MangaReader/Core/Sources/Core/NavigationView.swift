import History
import MangaList
import Models
import Styles
import SwiftData
import SwiftUI
import Detail

public struct NavigationView: View {

    @EnvironmentObject private var theme: Theme

    @State private var selectedTabIndex: Int = 0
    @State private var tabStack: [Int: NavigationPath] = [:]

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTabIndex) {
            Tab(value: 0) {
                NavigationStack(path: Binding(get: {
                    tabStack[selectedTabIndex, default: NavigationPath()]
                }, set: {
                    tabStack[selectedTabIndex] = $0
                })) {
                    MangaListScreen(viewModel: MangaListViewModel())
                        .navigationDestination(for: MangaViewModel.self) { mangaViewModel in
                            MangaDetailScreen(mangaSlug: mangaViewModel.slug)
                        }
                }
            } label: {
                VStack {
                    Text("Mangas")
                    Image(systemName: "list.bullet")
                }
            }

            Tab(value: 1) {
                NavigationStack(path: Binding(get: {
                    tabStack[selectedTabIndex, default: NavigationPath()]
                }, set: {
                    tabStack[selectedTabIndex] = $0
                })) {
                    Text("Under construction...")
                }
            } label: {
                VStack {
                    Text("Favorites")
                    Image(systemName: "star.fill")
                }
            }

            Tab(value: 2) {
                NavigationStack(path: Binding(get: {
                    tabStack[selectedTabIndex, default: NavigationPath()]
                }, set: {
                    tabStack[selectedTabIndex] = $0
                })) {
                    HistoryScreen()
                }
            } label: {
                VStack {
                    Text("History")
                    Image(systemName: "clock")
                }
            }
        }
        .tabViewStyle(.sidebarAdaptable)
        .tint(theme.toolbarTint)
    }

    private func handleDestinations() {}
}

#Preview() {
    NavigationView()
        .environmentObject(Theme())
}
