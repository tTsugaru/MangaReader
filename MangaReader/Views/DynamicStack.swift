import SwiftUI

enum DynamicStackAlignment {
    case leading
    case top
    case center
    case bottom
    case trailing
    
    var horizntalAlignment: HorizontalAlignment {
        switch self {
        case .leading:
            return .leading
        case .center:
            return .center
        case .trailing:
            return .trailing
        default:
            fatalError("Not supported alignment for VStack!")
        }
    }
    
    var verticalAlignment: VerticalAlignment {
        switch self {
        case .leading:
            return .firstTextBaseline
        case .top:
            return .top
        case .center:
            return .center
        case .bottom:
            return .bottom
        case .trailing:
            return .lastTextBaseline
        }
    }
}

struct DynamicStack<Content>: View where Content: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let content: () -> Content
    let alignment: DynamicStackAlignment?
    let spacing: CGFloat?

    init(alignment: DynamicStackAlignment? = nil, spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.alignment = alignment
        self.spacing = spacing
    }

    var body: some View {
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
