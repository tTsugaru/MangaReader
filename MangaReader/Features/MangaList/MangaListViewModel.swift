import Combine
import Foundation

@MainActor
class MangaListViewModel: ObservableObject {
    @Published var mangas: [MangaViewModel] = []
    @Published var isLoadingImages = false
    @Published var mangasAreLoadingImages: [Published<Bool>.Publisher] = []
    @Published var currentPageLoaded = 1
    
    func getAllMangas() async {
        guard mangas.isEmpty else { return }
        
        do {
            mangas = try await Networking.shared.search(page: 1).map { MangaViewModel(model: $0) }

            mangasAreLoadingImages = mangas.map(\.$isLoadingCoverImage)
            setupCoverLoadingBinding()
        } catch {
            print(error) // TODO: Handle error
        }
    }
    
    func loadNextPage() async {
        currentPageLoaded += 1
        
        do {
            let loadedNextMangas = try await Networking.shared.search(page: currentPageLoaded).map { MangaViewModel(model: $0) }
            mangas += loadedNextMangas
            mangasAreLoadingImages = loadedNextMangas.map(\.$isLoadingCoverImage)
        } catch {
            print(error)
        }
    }

    var cancellable: AnyCancellable? = nil
    func setupCoverLoadingBinding() {
        cancellable?.cancel()
        cancellable = Publishers.MergeMany(mangasAreLoadingImages).sink { [weak self] isLoadingImages in
            self?.isLoadingImages = isLoadingImages
        }
    }

    func forceUpdateView() {
        objectWillChange.send()
    }
}
