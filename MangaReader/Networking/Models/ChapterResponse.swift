import Foundation

struct IdentityTrait: Codable {
    let username: String
    let gravatar: String
}

struct Identities: Codable {
    let id: String
    let traits: IdentityTrait
}

struct Chapter: Codable {
    let id: Int
    let chap: String?
    let title: String?
    let vol: String?
    let lang: String
    let createdAt: String
    let updatedAt: String
    let upCount: Int
    let downCount: Int
    let groupName: [String]?
    let hid: String
    let identities: Identities?
    let mdChaptersGroups: [MdChaptersGroup]
    
    enum CodingKeys: String, CodingKey {
        case id, chap, title, vol, lang
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case upCount = "up_count"
        case downCount = "down_count"
        case groupName = "group_name"
        case hid, identities
        case mdChaptersGroups = "md_chapters_groups"
    }
}
struct MdChaptersGroup: Codable {
    let mdGroups: MdGroups
    
    enum CodingKeys: String, CodingKey {
        case mdGroups = "md_groups"
    }
}
struct MdGroups: Codable {
    let title: String
    let slug: String
}
struct ChapterResponse: Codable {
    let chapters: [Chapter]
    let total: Int
    let limit: Int
}
