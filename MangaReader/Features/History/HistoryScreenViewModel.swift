import Foundation

@MainActor
class HistoryScreenViewModel: ObservableObject {
    @Published var mangaViewModels = [MangaDetailViewModel]()
    @Published var isLoading = false
    @Published var isRemoving = false
    @Published var error: Error?

    func getMangaReadStates(isRefresh: Bool = false) async {
        isLoading = true
        error = nil

        do {
            // TODO: Re-add CloudKit
            let mangaReadStates = [MangaReadState]() /*try await Database.shared.getMangaReadStates()*/

            for mangaReadState in mangaReadStates {
                let mangaDetail = try? await Networking.shared.getMangaDetails(slug: mangaReadState.mangaSlug)
                guard let mangaDetail else { continue }
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

    func removeFromHistory(slug: String) async {
        do {
            isRemoving = true
            try await Database.shared.removeMangaReadState(with: slug)
            mangaViewModels.removeAll(where: { $0.slug == slug })
            isRemoving = false
        } catch {
            print(error)
            isRemoving = false
        }
    }
}
