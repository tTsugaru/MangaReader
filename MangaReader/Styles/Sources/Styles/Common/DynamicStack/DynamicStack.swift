//
//  DynamicStack.swift
//  Styles
//
//  Created by Jakub Gencer on 01.03.25.
//

import SwiftUI

public struct DynamicStack<Content>: View where Content: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    private let content: () -> Content
    private let alignment: DynamicStackAlignment?
    private let spacing: CGFloat?

    public init(alignment: DynamicStackAlignment? = nil, spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.alignment = alignment
        self.spacing = spacing
    }

    public var body: some View {
        if horizontalSizeClass == .compact {
            VStack(alignment: alignment?.horizntalAlignment ?? .center, spacing: spacing) {
                content()
            }
        } else {
            HStack(alignment: alignment?.verticalAlignment ?? .center, spacing: spacing) {
                content()
            }
        }
    }
}
