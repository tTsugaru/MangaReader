import Combine
import SwiftUI
import Foundation
import Kingfisher

@MainActor
class MangaListViewModel: ObservableObject {
    @Published var scrollPosition: String?
    
    @Published var mangas = [MangaViewModel]()
    @Published var isLoading = false
    @Published var isLoadingNextPage = false
    @Published var currentPageLoaded = 1
    @Published var error: Error?
    
    @Published var oldSelectedManga: MangaViewModel?
    
    func getAllMangas() async {
        guard mangas.isEmpty else { return }
        
        isLoading = true
        error = nil
        do {
            mangas = try await Networking.shared.search(page: 1, limit: 200).map { MangaViewModel(model: $0) }
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
    
    func loadNextPage(with limit: Int) async {
        currentPageLoaded += 1
        
        isLoadingNextPage = true
        error = nil
        do {
            let loadedNextMangas = try await Networking.shared.search(page: currentPageLoaded, limit: limit).map { MangaViewModel(model: $0) }
            mangas += loadedNextMangas
            isLoadingNextPage = false
        } catch {
            self.error = error
            isLoadingNextPage = false
        }
    }
}
