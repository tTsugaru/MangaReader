import Core
import Models
import Styles
import SwiftData
import SwiftUI

@main
struct MangaReaderApp: App {
    init() {
        Appearance.shared.setupAppearance()

        // Setup URLCache for caching images
        URLSession.shared.configuration.urlCache = URLCache(memoryCapacity: 500 * 1024 * 1024, diskCapacity: 800 * 1024 * 1024)
        URLSession.shared.configuration.requestCachePolicy = .returnCacheDataElseLoad
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environmentObject(Theme())
        }
        .modelContainer(for: [MangaReadState.self])
        #if os(macOS)
            .windowStyle(.hiddenTitleBar)
        #endif
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
        .environmentObject(Theme())
}
