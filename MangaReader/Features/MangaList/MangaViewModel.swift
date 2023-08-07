import Foundation
import SwiftUI

enum MangaStatus: Int {
    case unknown = 0
    case ongoing = 1
    case completed = 2
    case hiatus = 3
    case cancelled = 4
}

enum ContentRating: String {
    case safe
    case suggestive
    // Add more cases
}

enum Demographic: Int {
    case unknown = 0
    case shounen = 1
    case shoujo = 2
    // Add more cases
}

struct MangaCover: Codable {
    let w: Int
    let h: Int
    let b2key: String
}

struct MuComics: Codable {
    let year: Int
}

enum Genre: Int {
    case action = 246
    case adventure = 305
}

@MainActor
class MangaViewModel: ObservableObject {
    let model: Manga

    init(model: Manga) {
        self.model = model
        
        self.loadCoverImage()
    }

    var id: Int {
        model.id
    }

    var hid: String {
        model.hid
    }

    var slug: String {
        model.slug
    }

    var title: String {
        model.title
    }

    var rating: String? {
        model.rating
    }

    var bayesianRating: String? {
        model.bayesianRating
    }

    var ratingCount: Int? {
        model.ratingCount
    }

    var followCount: Int? {
        model.followCount
    }

    var desc: String? {
        model.desc
    }

    var status: MangaStatus {
        MangaStatus(rawValue: model.status) ?? .unknown
    }

    var lastChapter: Double? {
        model.lastChapter
    }

    var translationCompleted: Bool? {
        model.translationCompleted
    }

    var viewCount: Int? {
        model.viewCount
    }

    var contentRating: ContentRating? {
        ContentRating(rawValue: model.contentRating ?? "")
    }

    var demographic: Demographic? {
        Demographic(rawValue: model.demographic ?? 0)
    }

    var genres: [Genre] {
        model.genres.compactMap { Genre(rawValue: $0) }
    }

    var createdAt: String? {
        model.createdAt
    }

    var userFollowCount: Int? {
        model.userFollowCount
    }

    var year: Int {
        model.year
    }

    var mdTitles: [String]? {
        model.mdTitles?.map(\.title)
    }

    var mdCovers: [Cover]? {
        model.mdCovers
    }

    var muComics: MUComics? {
        model.muComics
    }

    var coverUrl: URL? {
        if let urlString = model.coverUrl, let url = URL(string: urlString) {
            return url
        } else {
            return nil
        }
    }
    
    @Published var image: Image? = nil
    @Published var isLoadingCoverImage: Bool = false
    
    func loadCoverImage() {
        guard let imageID = mdCovers?.first?.b2key, image == nil else { return }
        isLoadingCoverImage = true
        
        Task.detached(priority: .background) {
            do {
                let fetchedImage = try await API.loadImage(with: imageID)
                
                Task { @MainActor in
                    self.image = fetchedImage
                    self.isLoadingCoverImage = false
                }
            } catch {
                print(error)
                
                Task { @MainActor in
                    self.isLoadingCoverImage = false
                }
            }
        }
    }
}
