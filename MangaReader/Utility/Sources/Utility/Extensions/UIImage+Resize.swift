//
//  UIImage+Resize.swift
//  Utility
//
//  Created by Jakub Gencer on 01.03.25.
//

#if canImport(UIKit)
    import UIKit

    public extension UIImage {
        func resize(targetSize: CGSize) -> UIImage? {
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            return renderer.image { _ in
                self.draw(in: CGRect(origin: .zero, size: targetSize))
            }
        }
    }
#endif
