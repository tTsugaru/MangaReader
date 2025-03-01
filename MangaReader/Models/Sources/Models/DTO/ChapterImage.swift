//
//  ChapterImage.swift
//  Models
//
//  Created by Jakub Gencer on 01.03.25.
//

import Foundation

#warning("add support for images with b2Key")
public struct ChapterImage: Codable, Sendable {
    public let url: String?
    public let w, h: Int
    public let b2Key: String?
}
