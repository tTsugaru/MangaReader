//
//  ChapterDetail.swift
//  Models
//
//  Created by Jakub Gencer on 01.03.25.
//

import Foundation

public struct ChapterDetail: Codable, Sendable {
    public let id: Int
    public let chap: String
    public let vol: String?
    public let title: String?
    public let hid: String
    public let groupName: [String]
    public let chapterId: Int?
    public let createdAt, updatedAt: String
    public let crawledAt: String?
    public let mdid: String?
    public let commentCount, upCount, downCount: Int?
    public let status: String
    public let adsense: Bool
    public let lang: String
    public let mdComics: MdComics
    public let mdChaptersGroups: [MdChaptersGroup]?
    public let genres: [Int]?
    public let contentRating: String?
    public let chapterNumbersResetOnNewVolumeManual: Bool?
    public let noindex: Bool?
    public let coverUrl: String?
    public let images: [ChapterImage]?

    enum CodingKeys: String, CodingKey {
        case id, chap, vol, title, hid
        case groupName = "group_name"
        case chapterId = "chapter_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case crawledAt = "crawled_at"
        case mdid
        case commentCount = "comment_count"
        case upCount = "up_count"
        case downCount = "down_count"
        case status, adsense, lang
        case mdComics = "md_comics"
        case mdChaptersGroups = "md_chapters_groups"
        case genres
        case contentRating = "content_rating"
        case chapterNumbersResetOnNewVolumeManual = "chapter_numbers_reset_on_new_volume_manual"
        case noindex
        case coverUrl = "cover_url"
        case images
    }
}
