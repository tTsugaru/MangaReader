import SwiftData
import SwiftUI

@main
struct MangaReaderApp: App {
    init() {
        #if !os(macOS)
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterial)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance

            let navigationAppearance = UINavigationBarAppearance()
            navigationAppearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterial)
            UINavigationBar.appearance().standardAppearance = navigationAppearance
            UINavigationBar.appearance().compactAppearance = navigationAppearance
        #endif
    }

    var body: some Scene {
        WindowGroup {
            NavigationView()
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
