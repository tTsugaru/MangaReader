import CoreImage
import Kingfisher
import SwiftUI

#if canImport(UIKit)
    import UIKit
#endif

struct MangaDetailScreen: View {
    let manga: MangaViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HStack {
                        KFImage(manga.imageDownloadURL)
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 100, maxWidth: 500)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .shadow(radius: 5)
                            .transition(.slide)

                        VStack {
                            Text(manga.title)
                        }

                        Spacer()
                    }
                    .padding(16)

                    Spacer()
                }
                .frame(minHeight: geometry.size.height)
            }
            .background {
                FloatingCloudsView(colors: manga.prominentColors)
            }
            .background {
                manga.avrageCoverColor
                    .ignoresSafeArea()
            }
            .frame(width: geometry.size.width)
            .navigationTitle(manga.title)
        }
    }
}

extension KFCrossPlatformImage {
    var avrageColor: Color? {
        #if os(macOS)
            guard let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil) else { return nil }
        #elseif os(iOS)
            guard let cgImage = self.cgImage else { return nil }
        #endif
        let inputImage = CIImage(cgImage: cgImage)
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)

        return Color(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255)
    }

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
