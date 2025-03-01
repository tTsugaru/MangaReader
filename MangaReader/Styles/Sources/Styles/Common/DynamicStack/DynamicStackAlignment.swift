import SwiftUI

public enum DynamicStackAlignment {
    case leading
    case top
    case center
    case bottom
    case trailing

    public var horizntalAlignment: HorizontalAlignment {
        switch self {
        case .leading:
            return .leading
        case .center:
            return .center
        case .trailing:
            return .trailing
        default:
            return .leading
        }
    }

    public var verticalAlignment: VerticalAlignment {
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
