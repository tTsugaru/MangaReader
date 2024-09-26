//
//  Appearance.swift
//  MangaReader
//
//  Created by Jakub Gencer on 26.09.24.
//

import SwiftUI

@MainActor
struct Appearance {

    static let shared = Appearance()

    func setupAppearance() {
        if !Platform.isMacOS {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterial)
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance

            let navigationAppearance = UINavigationBarAppearance()
            navigationAppearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterial)
            UINavigationBar.appearance().standardAppearance = navigationAppearance
            UINavigationBar.appearance().compactAppearance = navigationAppearance
        }
    }
}

