import Foundation

public struct MUComicCategory: Codable, Sendable {
    public let muCategories: Category
    public let upVote: Int
    public let downVote: Int

    enum CodingKeys: String, CodingKey {
        case muCategories = "mu_categories"
        case upVote = "positive_vote"
        case downVote = "negative_vote"
    }
}
