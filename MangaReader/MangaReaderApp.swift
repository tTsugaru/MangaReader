import SwiftData
import SwiftUI

@main
struct MangaReaderApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .task {
                    URLSession.shared.configuration.urlCache = URLCache(memoryCapacity: 100 * 1024 * 1024, diskCapacity: 800 * 1024 * 1024)
                    URLSession.shared.configuration.requestCachePolicy = .returnCacheDataElseLoad
                }
        }
        #if os(macOS)
        .windowStyle(.hiddenTitleBar)
        #endif
    }
}
