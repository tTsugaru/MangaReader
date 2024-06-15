import Foundation
import SwiftData

@MainActor
class HistoryScreenViewModel: ObservableObject {
    @Published var mangaViewModels = [MangaDetailViewModel]()
    @Published var isLoading = false
    @Published var isRemoving = false
    @Published var error: Error?

    func fetchMangaViewModels(for mangaReadStates: [MangaReadState]) async {
        isLoading = true
        error = nil

        do {
            for mangaReadState in mangaReadStates {
                let mangaDetail = try await Networking.shared.getMangaDetails(slug: mangaReadState.mangaSlug)
                let mangaDetailViewModel = MangaDetailViewModel(mangaDetail)

                guard !mangaViewModels.contains(mangaDetailViewModel) else { continue }
                mangaViewModels.append(mangaDetailViewModel)
            }

            isLoading = false

        } catch {
            isLoading = false
            self.error = error
        }
    }
    
    func deleteMangaReadStates(for mangaSlug: String, modelContext: ModelContext) {
        do {
            try modelContext.delete(model: MangaReadState.self, where: #Predicate { $0.mangaSlug == mangaSlug })
            mangaViewModels.removeAll(where: { $0.slug == mangaSlug })
        } catch {
            print(error)
        }
    }
}
