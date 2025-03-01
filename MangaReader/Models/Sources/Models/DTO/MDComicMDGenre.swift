import Foundation

public struct MDComicMDGenre: Codable, Sendable {
    public let mdGenres: MDGenres
    
    enum CodingKeys: String, CodingKey {
        case mdGenres = "md_genres"
    }
}
