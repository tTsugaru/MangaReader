//
//  MangaButtonStyle.swift
//  Styles
//
//  Created by Jakub Gencer on 01.03.25.
//

import SwiftUI

public struct MangaButtonStyle: PrimitiveButtonStyle {
    @State var isHoveringOver: Bool = false

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .bold()
                .padding(16)
        }
        .background(isHoveringOver ? Color.black.opacity(0.5) : Color.black.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .contentShape(Rectangle())
        .onHover { self.isHoveringOver = $0 }
        .onTapGesture {
            configuration.trigger()
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0) // Visual response on iOS/iPadOS cause there is no hover
                .onChanged { _ in
                    isHoveringOver = true
                }
                .onEnded { _ in
                    isHoveringOver = false
                }
        )
    }
}
