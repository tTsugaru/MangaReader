import Foundation

public struct RelateFrom: Codable, Sendable {
    public let relateTo: RelateTo
    public let mdRelates: MDRelates
    
    enum CodingKeys: String, CodingKey {
        case relateTo = "relate_to"
        case mdRelates = "md_relates"
    }
}
