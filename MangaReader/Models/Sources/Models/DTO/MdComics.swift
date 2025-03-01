//
//  MdComics.swift
//  Models
//
//  Created by Jakub Gencer on 01.03.25.
//

import Foundation

public struct MdComics: Codable, Sendable {
    public let id: Int
    public let title, country, slug, desc: String?
    public let links: MdComicLinks
    public let genres: [Int]
    public let hid, contentRating: String
    public let chapterNumbersResetOnNewVolumeManual: Bool
    public let noindex: Bool
    public let muComics: MUComics

    enum CodingKeys: String, CodingKey {
        case id, title, country, slug, desc, links, genres, hid
        case contentRating = "content_rating"
        case chapterNumbersResetOnNewVolumeManual = "chapter_numbers_reset_on_new_volume_manual"
        case noindex
        case muComics = "mu_comics"
    }
}
