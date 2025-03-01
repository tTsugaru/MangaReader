import Combine
import Foundation
import Kingfisher
import Models
import Networking
import SwiftUI

@MainActor
public class MangaListViewModel: ObservableObject {
    @Published public var scrollPosition: String?
    
    @Published public var mangas = [MangaViewModel]()
    @Published public var isLoading = false
    @Published public var isLoadingNextPage = false
    @Published public var currentPageLoaded = 1
    @Published public var error: Error?
    
    @Published public var oldSelectedManga: MangaViewModel?
    
    public init() {
        // no-op
    }
    
    public func getAllMangas() async {
        isLoading = true
        error = nil
        do {
            let networkTask = Task.detached {
                return try await Networking.shared.search(page: 1, limit: 12).map { MangaViewModel(model: $0) }
            }
            
            mangas = try await networkTask.value
            
            isLoading = false
        } catch {
            self.error = error
            isLoading = false
        }
    }
    
    public func loadNextPage(with limit: Int = 12) async {
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
