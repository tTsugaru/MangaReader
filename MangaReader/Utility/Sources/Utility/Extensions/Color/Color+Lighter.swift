//
//  Color+Lighter.swift
//  Utility
//
//  Created by Jakub Gencer on 01.03.25.
//

import SwiftUI

public extension Color {
    func lighter(by percentage: CGFloat = 0.2) -> Color {
        #if os(macOS)
            guard let color = NSColor(self).adjusted(by: abs(percentage)) else {
                return self
            }
        #else
            guard let color = UIColor(self).adjusted(by: abs(percentage)) else {
                return self
            }
        #endif

        return Color(color)
    }
}
