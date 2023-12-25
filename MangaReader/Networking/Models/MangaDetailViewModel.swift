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

    var imageDownloadURL: CoverViewModel? {
        guard let cover = model.comic.mdCovers.first else { return nil }
        return CoverViewModel(model: cover)
    }
}
struct CoverViewModel {
    private let model: Cover
    
    init(model: Cover) {
        self.model = model
    }
    
    var b2Key: String {
        return model.b2key
    }
    var h: Int {
        return model.h
    }
    var w: Int {
        return model.w
    }
    
    var downloadURL: URL? {
        return URL(string: "https://meo.comick.pictures/\(self.b2Key)")
    }
}
