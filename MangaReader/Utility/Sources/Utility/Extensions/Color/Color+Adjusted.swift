//
//  Color+Adjusted.swift
//  Utility
//
//  Created by Jakub Gencer on 01.03.25.
//

import SwiftUI

#if os(macOS)
    extension NSColor {
        func adjusted(by percentage: CGFloat) -> NSColor? {
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            var alpha: CGFloat = 0

            getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)

            let adjustedBrightness = max(min(brightness + percentage, 1.0), 0.0)
            return NSColor(hue: hue, saturation: saturation, brightness: adjustedBrightness, alpha: alpha)
        }
    }
#else
    extension UIColor {
        func adjusted(by percentage: CGFloat) -> UIColor? {
            var hue: CGFloat = 0
            var saturation: CGFloat = 0
            var brightness: CGFloat = 0
            var alpha: CGFloat = 0

            guard getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) else {
                return nil
            }

            let adjustedBrightness = max(min(brightness + percentage, 1.0), 0.0)
            return UIColor(hue: hue, saturation: saturation, brightness: adjustedBrightness, alpha: alpha)
        }
    }
#endif
