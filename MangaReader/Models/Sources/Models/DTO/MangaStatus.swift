import Foundation

public enum MangaStatus: Int, Sendable {
    case unknown = 0
    case ongoing = 1
    case completed = 2
    case hiatus = 3
    case cancelled = 4
}
