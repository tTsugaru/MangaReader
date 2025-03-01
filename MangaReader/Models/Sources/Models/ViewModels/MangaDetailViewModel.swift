import Foundation
import Utility

public final class MangaDetailViewModel: Identifiable, MangaListViewProtocol {
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
        hid = model.comic.hid
        title = model.comic.title
        slug = model.comic.slug
        alternativeTitles = model.comic.mdTitles.filter { $0.lang == "en" }.map(\.title).joined(separator: "\n")
        year = model.comic.year
        authors = model.authors?.map(\.name).joined(separator: ", ")
        artists = model.artists?.map(\.name).joined(separator: ", ")
        description = model.comic.description
        sanitizedDescription = description?.trimmingCharacters(in: .whitespacesAndNewlines)
        firstChapterId = model.firstChap.hid

        if let cover = model.comic.mdCovers.first {
            let coverViewModel = CoverViewModel(model: cover)

            imageDownloadURL = coverViewModel.downloadURL
            self.coverViewModel = coverViewModel
        } else {
            imageDownloadURL = nil
            coverViewModel = nil
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
