import Foundation
import SwiftUI
import OSLog

extension View {
    public var logger: Logger {
        Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: Self.self))
    }
}
