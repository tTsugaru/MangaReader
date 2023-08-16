import Kingfisher
import SwiftUI

#if canImport(UIKit)
    import UIKit
#endif

struct MangaDetailScreen: View {
    let manga: MangaViewModel

    @State var backgroundColor: Color? = nil

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HStack {
                        KFImage(manga.imageDownloadURL)
                            .onSuccess { result in
                                backgroundColor = result.image.dominantColor
                            }
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 200, maxWidth: 500)
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
                if let backgroundColor {
                    backgroundColor
                        .ignoresSafeArea()
                }
            }
            .frame(width: geometry.size.width)
            .toolbar(.hidden, for: .windowToolbar)
            .navigationTitle(manga.title)
        }
    }
}

#if os(macOS)
    extension NSImage {
        var dominantColor: Color? {
            guard let cgImage = cgImage(forProposedRect: nil, context: nil, hints: nil) else {
                return nil
            }

            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let pixels = UnsafeMutablePointer<UInt8>.allocate(capacity: 4)
            defer {
                pixels.deallocate()
            }

            let context = CGContext(
                data: pixels,
                width: 1,
                height: 1,
                bitsPerComponent: 8,
                bytesPerRow: 4,
                space: colorSpace,
                bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue
            )

            context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: 1, height: 1))

            let red = CGFloat(pixels[0]) / 255.0
            let green = CGFloat(pixels[1]) / 255.0
            let blue = CGFloat(pixels[2]) / 255.0

            return Color(red: red, green: green, blue: blue)
        }
    }

#elseif os(iOS)
    extension UIImage {
        var avarageColor: Color? {
            guard let imageData = pngData() else { return nil }

            var totalRed: CGFloat = 0
            var totalGreen: CGFloat = 0
            var totalBlue: CGFloat = 0

            let pixelCount = size.width * size.height

            imageData.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
                for pixelIndex in stride(from: 0, to: bytes.count, by: 4) {
                    let red = CGFloat(bytes[pixelIndex]) / 255.0
                    let green = CGFloat(bytes[pixelIndex + 1]) / 255.0
                    let blue = CGFloat(bytes[pixelIndex + 2]) / 255.0

                    totalRed += red
                    totalGreen += green
                    totalBlue += blue
                }
            }

            let averageRed = totalRed / CGFloat(pixelCount)
            let averageGreen = totalGreen / CGFloat(pixelCount)
            let averageBlue = totalBlue / CGFloat(pixelCount)

            return Color(red: Double(averageRed), green: Double(averageGreen), blue: Double(averageBlue))
        }
    }
#endif
