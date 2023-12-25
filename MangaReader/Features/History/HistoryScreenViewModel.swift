import Foundation

@MainActor
class HistoryScreenViewModel: ObservableObject {
    
    @Published var mangaViewModels = [MangaDetailViewModel]()
    @Published var isLoading = false
    @Published var error: Error?
    
    func getMangaReadStates() async {
        isLoading = true
        error = nil
        
        do {
            let mangaReadStates = try await Database.shared.getMangaReadStates()
            
            print("MangaReadStates", mangaReadStates.count)
            
            for mangaReadState in mangaReadStates {
                let mangaDetail =  try? await Networking.shared.getMangaDetails(slug: mangaReadState.mangaSlug)
                guard let mangaDetail else { continue }
                let mangaDetailViewModel = MangaDetailViewModel(mangaDetail)
                
                print("Test", mangaReadState.mangaSlug)
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
            try await Database.shared.removeMangaReadState(with: slug)
            mangaViewModels.removeAll(where: { $0.slug == slug })
        } catch {
            print(error)
        }
    }
    
}
