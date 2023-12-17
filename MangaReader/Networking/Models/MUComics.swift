import Foundation

struct MUComics: Codable {
    let year: Int
    let muComicPublishers: [MuComicPublisher]
    let licensedInEnglish: String?
    let muComicCategories: [String]
}

struct MuComicPublisher: Codable {
    let muPublishers: MuPublishers
}

struct MuPublishers: Codable {
    let title: String
    let slug: String
}
