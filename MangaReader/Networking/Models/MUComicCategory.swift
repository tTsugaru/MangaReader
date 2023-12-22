import Foundation

struct MUComicCategory: Codable {
    let muCategories: Category
    let upVote: Int
    let downVote: Int

    enum CodingKeys: String, CodingKey {
        case muCategories = "mu_categories"
        case upVote = "positive_vote"
        case downVote = "negative_vote"
    }
}
