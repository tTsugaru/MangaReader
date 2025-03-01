//
//  ChapterImage.swift
//  Models
//
//  Created by Jakub Gencer on 01.03.25.
//

import Foundation

public struct ChapterImage: Codable, Sendable {
    public let url: String?
    public let width, height: Int
    public let b2Key: String?

    enum CodingKeys: String, CodingKey {
        case url
        case width = "w"
        case height = "h"
        case b2Key
    }
}
