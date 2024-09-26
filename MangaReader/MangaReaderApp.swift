import CoreData
import SwiftData
import SwiftUI

@main
struct MangaReaderApp: App {

    let modelContainer: ModelContainer

    init() {
        Appearance.shared.setupAppearance()

        let config = ModelConfiguration()

        do {
            #if DEBUG
                // Use an autorelease pool to make sure Swift deallocates the persistent
                // container before setting up the SwiftData stack.
                try autoreleasepool {
                    let desc = NSPersistentStoreDescription(url: config.url)
                    let opts = NSPersistentCloudKitContainerOptions(containerIdentifier: "iCloud.at.tsugaru.MangaReader")
                    desc.cloudKitContainerOptions = opts
                    // Load the store synchronously so it completes before initializing the
                    // CloudKit schema.
                    desc.shouldAddStoreAsynchronously = false
                    if let mom = NSManagedObjectModel.makeManagedObjectModel(for: [MangaReadState.self]) {
                        let container = NSPersistentCloudKitContainer(name: "development", managedObjectModel: mom)
                        container.persistentStoreDescriptions = [desc]
                        container.loadPersistentStores { _, err in
                            if let err {
                                fatalError(err.localizedDescription)
                            }
                        }
                        // Initialize the CloudKit schema after the store finishes loading.
                        try container.initializeCloudKitSchema()
                        // Remove and unload the store from the persistent container.
                        if let store = container.persistentStoreCoordinator.persistentStores.first {
                            try container.persistentStoreCoordinator.remove(store)
                        }
                    }
                }
            #endif
            modelContainer = try ModelContainer(for: MangaReadState.self, configurations: config)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        // Setup URLCache for caching images
        URLSession.shared.configuration.urlCache = URLCache(memoryCapacity: 500 * 1024 * 1024, diskCapacity: 800 * 1024 * 1024)
        URLSession.shared.configuration.requestCachePolicy = .returnCacheDataElseLoad
    }

    var body: some Scene {
        WindowGroup {
            NavigationView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(for: [MangaReadState.self])
        #if os(macOS)
            .windowStyle(.hiddenTitleBar)
        #endif
    }
}
