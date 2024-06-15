import Foundation

final class MangaDetailViewModel: Identifiable, MangaListViewProtocol {
    
    let hid: String
    let title: String
    let slug: String
    let alternativeTitles: String
    let year: Int
    let authors: String?
    let artists: String?
    let description: String?
    let sanitizedDescription: String?
    let firstChapterId: String
    let coverViewModel: CoverViewModel?
    let imageDownloadURL: URL?
    
    init(_ model: MangaDetail) {
        self.hid = model.comic.hid
        self.title = model.comic.title
        self.slug = model.comic.slug
        self.alternativeTitles = model.comic.mdTitles.filter{ $0.lang == "en" }.map(\.title).joined(separator: "\n")
        self.year = model.comic.year
        self.authors = model.authors?.map(\.name).joined(separator: ", ")
        self.artists = model.artists?.map(\.name).joined(separator: ", ")
        self.description = model.comic.description
        self.sanitizedDescription = description?.trimmingCharacters(in: .whitespacesAndNewlines)
        self.firstChapterId = model.firstChap.hid
        
        if let cover = model.comic.mdCovers.first {
            let coverViewModel = CoverViewModel(model: cover)
            
            self.imageDownloadURL = coverViewModel.downloadURL
            self.coverViewModel = coverViewModel
        } else {
            self.imageDownloadURL = nil
            self.coverViewModel = nil
        }
    }
}
extension MangaDetailViewModel: Equatable {
    static func == (lhs: MangaDetailViewModel, rhs: MangaDetailViewModel) -> Bool {
        lhs.slug == rhs.slug
    }
}
extension MangaDetailViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
