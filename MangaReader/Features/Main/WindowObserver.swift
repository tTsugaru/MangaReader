import SwiftUI

class WindowObserver: NSObject, ObservableObject {
    @Published var windowIsResizing = false
}

#if os(macOS)
    extension WindowObserver: NSWindowDelegate {
        func windowWillResize(_: NSWindow, to frameSize: NSSize) -> NSSize {
            windowIsResizing = true
            return frameSize
        }

        func windowDidResize(_: Notification) {
            windowIsResizing = false
        }
    }
#endif
