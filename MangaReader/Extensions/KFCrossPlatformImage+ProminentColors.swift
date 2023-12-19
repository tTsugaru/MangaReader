import Foundation
import Kingfisher
import SwiftUI

actor ColorCollector {
    let rows: [ArraySlice<UInt8>]
    let width: Int

    init(rows: [ArraySlice<UInt8>], width: Int) {
        self.rows = rows
        self.width = width
    }

    var colors: [Color] = []

    func createColors() async {
        await withTaskGroup(of: Void.self) { group in
            for row in rows {
                group.addTask {
                    for x in 0 ..< self.width {
                        let index = x * 4
                        let red = CGFloat(row[index]) / 255.0
                        let green = CGFloat(row[index + 1]) / 255.0
                        let blue = CGFloat(row[index + 2]) / 255.0
                        let alpha = CGFloat(row[index + 3]) / 255.0

                        await self.addColors([Color(red: red, green: green, blue: blue, opacity: alpha)])
                    }
                }
            }
        }
    }

    func addColors(_ newColors: [Color]) {
        colors.append(contentsOf: newColors)
    }

    func getAllColors() -> [Color] {
        colors
    }
}

extension KFCrossPlatformImage {
    func prominentColors() async -> [Color] {
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

        var rows = [ArraySlice<UInt8>]()
        rows.reserveCapacity(height)

        for y in 0 ..< height {
            rows.append(rawData[(bytesPerRow * y) ..< (bytesPerRow * (y + 1))])
        }

        let actor = ColorCollector(rows: rows, width: width)
        
        await actor.createColors()
        return await actor.getAllColors()
    }
}

extension KFCrossPlatformImage {
    func resize(width: Int, height: Int) -> KFCrossPlatformImage? {
        resize(targetSize: CGSize(width: width, height: height))
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
            draw(in: NSRect(origin: .zero, size: targetSize))
            return resizedImage
        }
    }

#else
    extension UIImage {
        func resize(targetSize: CGSize) -> UIImage? {
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            return renderer.image { _ in
                self.draw(in: CGRect(origin: .zero, size: targetSize))
            }
        }
    }
#endif
