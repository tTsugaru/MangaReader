import Foundation

enum SearchSortType: String {
    case follow
    case view
    case createdAt = "created_at"
    case uploaded
    case rating
    case userFollowCount = "user_follow_count"
}
