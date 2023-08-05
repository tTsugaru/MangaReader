import Combine
import Foundation

@MainActor
class MangaListViewModel: ObservableObject {
    @Published var mangas: [MangaViewModel] = []
    @Published var isLoadingImages = false
    @Published var mangasAreLoadingImages: [Published<Bool>.Publisher] = []

    func getAllMangas() async {
        do {
            mangas = try await Networking.shared.search().map { MangaViewModel(model: $0) }

            mangasAreLoadingImages = mangas.map(\.$isLoadingCoverImage)
            setupCoverLoadingBinding()
        } catch {
            print(error) // TODO: Handle error
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
