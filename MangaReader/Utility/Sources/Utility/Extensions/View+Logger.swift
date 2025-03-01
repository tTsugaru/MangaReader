import Foundation
import OSLog
import SwiftUI

public extension View {
    var logger: Logger {
        Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: Self.self))
    }
}
