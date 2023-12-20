import Combine
import SwiftUI
import Foundation
import Kingfisher

@MainActor
class MangaListViewModel: ObservableObject {
    @Published var mangas: [MangaViewModel] = []
    @Published var isLoading: Bool = false
    @Published var currentPageLoaded = 1
    
    @Published var oldSelectedManga: MangaViewModel?
    @Published var fetchColorTasks = [String: Task<Void, Never>]()
    
    func getAllMangas() async {
        guard mangas.isEmpty else { return }
        
        isLoading = true
        do {
            mangas = try await Networking.shared.search(page: 1).map { MangaViewModel(model: $0) }
            isLoading = false
        } catch {
            print(error) // TODO: Handle error
        }
    }
    
    func loadNextPage(with limit: Int) async {
        guard !isLoading else { return }
        currentPageLoaded += 1
        
        isLoading = true
        do {
            let loadedNextMangas = try await Networking.shared.search(page: currentPageLoaded, limit: limit).map { MangaViewModel(model: $0) }
            mangas += loadedNextMangas
            isLoading = false
        } catch {
            print(error)
        }
    }
}
