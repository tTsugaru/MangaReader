//
//  Platform.swift
//  MangaReader
//
//  Created by Jakub Gencer on 26.09.24.
//

import Foundation

enum Platform {
    case macOS
    case iOS

    static var current: Platform {
        #if os(macOS)
            return .macOS
        #elseif os(iOS)
            return .iOS
        #endif
    }

    static var isMacOS: Bool {
        self.current == .macOS
    }
}
