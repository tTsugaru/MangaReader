import Foundation

public struct FirstChapter: Codable, Sendable {
    public let chap: String?
    public let hid: String
    public let lang: String
    public let groupName: [String]?
    public let vol: String?

    enum CodingKeys: String, CodingKey {
        case chap
        case hid
        case lang
        case groupName = "group_name"
        case vol
    }
}
