import Foundation

@MainActor
class MangaDetailScreenViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var mangaDetail: MangaDetail?
    
    func getMangaDetail(slug: String) async {
        do {
            isLoading = true
            let mangaDetail = try await Networking.shared.getMangaDetails(slug: slug)
            self.mangaDetail = mangaDetail
            isLoading = false
        } catch {
            print(error)
        }
    }
}
