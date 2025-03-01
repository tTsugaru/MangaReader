import Foundation

public enum SearchSortType: String, Sendable {
    case follow
    case view
    case createdAt = "created_at"
    case uploaded
    case rating
    case userFollowCount = "user_follow_count"
}
