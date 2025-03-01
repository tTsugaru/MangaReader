//
//  NSImage+Resize.swift
//  Utility
//
//  Created by Jakub Gencer on 01.03.25.
//

#if canImport(AppKit)
    import AppKit

    public extension NSImage {
        func resize(targetSize: CGSize) -> NSImage? {
            let resizedImage = NSImage(size: targetSize)
            resizedImage.lockFocus()

            defer {
                resizedImage.unlockFocus()
            }

            guard let context = NSGraphicsContext.current else { return nil }
            context.imageInterpolation = .high
            draw(in: NSRect(origin: .zero, size: targetSize))
            return resizedImage
        }
    }
#endif
