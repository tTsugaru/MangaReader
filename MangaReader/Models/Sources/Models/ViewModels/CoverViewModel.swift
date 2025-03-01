import Foundation

public struct CoverViewModel: Sendable {
    private let model: Cover
    
    public init(model: Cover) {
        self.model = model
    }
    
    public var b2Key: String? {
        return model.b2key
    }
    
    public var height: Int {
        return model.height ?? 0
    }
    
    public var width: Int {
        return model.width ?? 0
    }
    
    public var downloadURL: URL? {
        guard let b2Key else { return nil }
        return URL(string: "https://meo.comick.pictures/\(b2Key)")
    }
}
