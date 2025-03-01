//
//  Color+isLightColor.swift
//  Utility
//
//  Created by Jakub Gencer on 01.03.25.
//

import SwiftUI

extension Color {
    var isLightColor: Bool {
        self.brightness == .light
    }
}
