//
//  Identities.swift
//  Models
//
//  Created by Jakub Gencer on 01.03.25.
//

import Foundation

public struct Identities: Codable, Sendable {
    public let id: String
    public let traits: IdentityTrait
}
