import Foundation

@MainActor
class MangaListViewModel: ObservableObject {
    
    @Published var mangas: [Manga] = []
    
    func getAllMangas() async {
        do {
            mangas = try await Networking.shared.getAllMangas()
        } catch {
            print(error) // TODO: Handle error
        }
    }
}
