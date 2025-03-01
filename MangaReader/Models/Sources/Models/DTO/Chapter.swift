//
//  Chapter.swift
//  Models
//
//  Created by Jakub Gencer on 01.03.25.
//

import Foundation

public struct Chapter: Codable, Sendable {
    public let id: Int
    public let chap: String?
    public let title: String?
    public let vol: String?
    public let lang: String
    public let createdAt: String
    public let updatedAt: String
    public let upCount: Int
    public let downCount: Int
    public let groupName: [String]?
    public let hid: String
    public let identities: Identities?
    public let mdChaptersGroups: [MdChaptersGroup]

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
