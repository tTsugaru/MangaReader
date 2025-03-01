//
//  MdChaptersGroup.swift
//  Models
//
//  Created by Jakub Gencer on 01.03.25.
//

import Foundation

public struct MdChaptersGroup: Codable, Sendable {
    public let mdGroups: MdGroups

    enum CodingKeys: String, CodingKey {
        case mdGroups = "md_groups"
    }
}
