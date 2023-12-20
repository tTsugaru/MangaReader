import SwiftUI

class FloatingCloudsViewModel: ObservableObject {
    @Published var cloudsColorViewModel = [FloatingCloudsColorViewModel]()

    private var frameAlignments: [Alignment] = [
        .center,
        .bottom,
        .bottomLeading,
        .bottomTrailing,
        .topLeading,
        .topTrailing,
        .top,
    ]

    func createFloatingCloudsColorViewModels(colors: [Color]) {
        colors.forEach { color in
            cloudsColorViewModel.append(FloatingCloudsColorViewModel(color: color,
                                                                     rotationStart: Double.random(in: 50 ... 200),
                                                                     duration: TimeInterval(Int.random(in: 5 ... 10)),
                                                                     alignment: frameAlignments[
                                                                         Int.random(in: 0 ... frameAlignments.count - 1)
                                                                     ]))
        }
    }
}
