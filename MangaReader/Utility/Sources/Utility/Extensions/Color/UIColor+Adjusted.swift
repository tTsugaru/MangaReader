//
//  UIColor+Adjusted.swift
//  Utility
//
//  Created by Jakub Gencer on 01.03.25.
//

import SwiftUI

#if os(iOS)
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
