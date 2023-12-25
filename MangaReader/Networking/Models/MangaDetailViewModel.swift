import Foundation

class MangaDetailViewModel: ObservableObject, Identifiable, MangaListViewProtocol {
    let model: MangaDetail

    init(_ model: MangaDetail) {
        self.model = model
    }

    var hid: String {
        model.comic.hid
    }

    var title: String {
        model.comic.title
    }
    
    var slug: String {
        model.comic.slug
    }

    var alternativeTitles: String {
        model.comic.mdTitles.filter{ $0.lang == "en" }.map(\.title).joined(separator: "\n")
    }

    var year: Int {
        model.comic.year
    }

    var authors: String? {
        model.authors?.map(\.name).joined(separator: ", ")
    }

    var artists: String? {
        model.artists?.map(\.name).joined(separator: ", ")
    }

    var description: String? {
        model.comic.description
    }

    var sanitizedDescription: String? {
        description?.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    var firstChapterId: String {
        return model.firstChap.hid
    }

    var coverViewModel: CoverViewModel? {
        guard let cover = model.comic.mdCovers.first else { return nil }
        return CoverViewModel(model: cover)
    }
    
    var imageDownloadURL: URL? {
        coverViewModel?.downloadURL
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
