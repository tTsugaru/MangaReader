import Foundation
import Utility

final public class MangaDetailViewModel: Identifiable, MangaListViewProtocol {
    
    public let hid: String
    public let title: String
    public let slug: String
    public let alternativeTitles: String
    public let year: Int
    public let authors: String?
    public let artists: String?
    public let description: String?
    public let sanitizedDescription: String?
    public let firstChapterId: String
    public let coverViewModel: CoverViewModel?
    public let imageDownloadURL: URL?
    
    public init(_ model: MangaDetail) {
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
    public static func == (lhs: MangaDetailViewModel, rhs: MangaDetailViewModel) -> Bool {
        lhs.slug == rhs.slug
    }
}
extension MangaDetailViewModel: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
