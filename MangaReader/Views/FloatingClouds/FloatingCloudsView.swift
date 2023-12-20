import SwiftUI

struct FloatingCloudsView: View {
    @StateObject var viewModel = FloatingCloudsViewModel()
    
    var colors: [Color]
    
    init(colors: [Color]) {
        self.colors = colors
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ZStack {
                    ForEach(Array(viewModel.cloudsColorViewModel.enumerated()), id: \.offset) { index, color in
                        Cloud(proxy: proxy,
                              color: color.color,
                              rotationStart: color.rotationStart,
                              duration: color.duration,
                              alignment: color.alignment)
                    }
                }
                .blur(radius: 60)
                .task {
                    viewModel.createFloatingCloudsColorViewModels(colors: colors)
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    FloatingCloudsView(colors: [.red, .green, .yellow, .blue])
}
