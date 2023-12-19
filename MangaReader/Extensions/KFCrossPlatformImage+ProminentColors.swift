import Foundation
import Kingfisher
import SwiftUI

extension KFCrossPlatformImage {
    var prominentColors: [Color] {
        #if os(macOS)
            guard let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil) else { return [] }
        #elseif os(iOS)
            guard let cgImage = self.cgImage else { return [] }
        #endif
        let inputImage = CIImage(cgImage: cgImage)
        let inputExtent = CIVector(cgRect: inputImage.extent)

        guard let kMeansFilter = CIFilter(name: "CIKMeans") else { return [] }
        kMeansFilter.setValue(inputImage, forKey: kCIInputImageKey)
        kMeansFilter.setValue(inputExtent, forKey: "inputExtent")
        // How many clusters should be used 0-128
        kMeansFilter.setValue(5, forKey: "inputCount")
        // How many passes should be performed 0-20
        kMeansFilter.setValue(20, forKey: "inputPasses")
        kMeansFilter.setValue(true, forKey: "inputPerceptual")

        guard let outputImage = kMeansFilter.outputImage else { return [] }

        let context = CIContext()

        guard let contextCGImage = context.createCGImage(outputImage, from: outputImage.extent) else { return [] }

        let width = contextCGImage.width
        let height = contextCGImage.height
        let bytesPerPixel = 4
        let bytesPerRow = 4 * width
        let totalBytes = bytesPerRow * height

        var rawData = [UInt8](repeating: 0, count: totalBytes)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)

        let bitsPerComponent = 8

        guard let outputImageContext = CGContext(data: &rawData,
                                                 width: width,
                                                 height: height,
                                                 bitsPerComponent: bitsPerComponent,
                                                 bytesPerRow: bytesPerRow,
                                                 space: colorSpace,
                                                 bitmapInfo: bitmapInfo.rawValue) else { return [] }

        outputImageContext.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))

        var colors = [Color]()
        for y in 0 ..< height {
            for x in 0 ..< width {
                let index = (y * bytesPerRow) + (x * bytesPerPixel)
                let red = CGFloat(rawData[index]) / 255.0
                let green = CGFloat(rawData[index + 1]) / 255.0
                let blue = CGFloat(rawData[index + 2]) / 255.0
                let alpha = CGFloat(rawData[index + 3]) / 255.0
                colors.append(Color(red: red, green: green, blue: blue, opacity: alpha))
            }
        }

        return colors
    }
}
extension KFCrossPlatformImage {
    func resize(width: Int, height: Int) -> KFCrossPlatformImage? {
        return self.resize(targetSize: CGSize(width: width, height: height))
    }
}

#if os(macOS)
extension NSImage {
    func resize(targetSize: CGSize) -> NSImage? {
        let resizedImage = NSImage(size: targetSize)
        resizedImage.lockFocus()
        
        defer {
            resizedImage.unlockFocus()
        }
        
        guard let context = NSGraphicsContext.current else { return nil }
        context.imageInterpolation = .high
        self.draw(in: NSRect(origin: .zero, size: targetSize))
        return resizedImage
    }
}

#else
extension UIImage {
    func resize(targetSize: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
#endif
