import Foundation

struct RelateFrom: Codable {
    let relateTo: RelateTo
    let mdRelates: MDRelates
    
    enum CodingKeys: String, CodingKey {
        case relateTo = "relate_to"
        case mdRelates = "md_relates"
    }
}
