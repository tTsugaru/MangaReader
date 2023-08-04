//
//  MangaReaderApp.swift
//  MangaReader
//
//  Created by Jakub Gencer on 04.08.23.
//

import SwiftUI
import SwiftData

@main
struct MangaReaderApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Item.self)
    }
}
