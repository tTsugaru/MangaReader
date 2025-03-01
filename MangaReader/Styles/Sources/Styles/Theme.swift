//
//  Theme.swift
//  Styles
//
//  Created by Jakub Gencer on 01.03.25.
//

import Foundation
import SwiftUI

public class Theme: ObservableObject {
    @Published public var toolbarTint: Color = Styles.TintColor.toolbar
    @Published public var tabBarTint: Color = Styles.TintColor.tabBar

    public init() {
        // no-op
    }
}
