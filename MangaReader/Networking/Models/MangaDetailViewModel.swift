import Foundation

class MangaDetailViewModel: ObservableObject, Identifiable {
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

    var alternativeTitles: String {
        model.comic.mdTitles.map(\.title).joined(separator: "\n")
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

    var imageDownloadURL: URL? {
        guard let imageId = model.comic.mdCovers.first?.b2key else { return nil }
        return URL(string: "https://meo.comick.pictures/\(imageId)")
    }
}
