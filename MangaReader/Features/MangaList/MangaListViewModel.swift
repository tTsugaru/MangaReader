import Combine
import Foundation
import Kingfisher
import SwiftUI

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
        isLoading = true
        error = nil
        do {
            let networkTask = Task.detached {
                return try await Networking.shared.search(page: 1, limit: 30).map { MangaViewModel(model: $0) }
            }
            
            mangas = try await networkTask.value
            
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
    
    func loadNextPage(with limit: Int = 30) async {
        do {
            isLoadingNextPage = true
            error = nil
            
            let networkTask = Task.detached {
                return try await Networking.shared.search(page: self.currentPageLoaded + 1, limit: limit).map { MangaViewModel(model: $0) }
            }
            
            mangas += try await networkTask.value
            currentPageLoaded += 1
            isLoadingNextPage = false
        } catch {
            self.error = error
            isLoadingNextPage = false
        }
    }
}
