import SwiftUI

class FloatingCloudsColorViewModel {
    let color: Color
    let rotationStart: Double
    let duration: TimeInterval
    let alignment: Alignment
    
    init(color: Color, rotationStart: Double, duration: TimeInterval, alignment: Alignment) {
        self.color = color
        self.rotationStart = rotationStart
        self.duration = duration
        self.alignment = alignment
    }
}
