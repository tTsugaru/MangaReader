import Foundation

struct FirstChapter: Codable {
    let chap: String
    let hid: String
    let lang: String
    let groupName: [String]?
    let vol: String?
    
    enum CodingKeys: String, CodingKey {
        case chap
        case hid
        case lang
        case groupName = "group_name"
        case vol
    }
}
