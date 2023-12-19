import SwiftUI

#if os(macOS)
struct BlurView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let blurView = NSVisualEffectView()
        blurView.material = material
        blurView.blendingMode = blendingMode
        return blurView
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}
#else
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    typealias UIViewType = UIVisualEffectView
    
    func makeUIView(context _: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context _: Context) {
        uiView.effect = UIBlurEffect(style: style)
    }
}
#endif
