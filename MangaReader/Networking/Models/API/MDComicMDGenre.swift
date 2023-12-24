import Foundation

struct MDComicMDGenre: Codable {
    let mdGenres: MDGenres
    
    enum CodingKeys: String, CodingKey {
        case mdGenres = "md_genres"
    }
}
