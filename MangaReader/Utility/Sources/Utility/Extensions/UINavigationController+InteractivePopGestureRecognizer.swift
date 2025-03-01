// swiftlint:disable override_in_extension
#if canImport(UIKit)
    import UIKit

    extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
        override open func viewDidLoad() {
            super.viewDidLoad()
            interactivePopGestureRecognizer?.delegate = self
        }

        public func gestureRecognizerShouldBegin(_: UIGestureRecognizer) -> Bool {
            return viewControllers.count > 1
        }
    }
#endif
// swiftlint:enable override_in_extension
