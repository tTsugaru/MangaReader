import Foundation

public struct CoverViewModel: Sendable {
    private let model: Cover
    
    public init(model: Cover) {
        self.model = model
    }
    
    public var b2Key: String? {
        return model.b2key
    }
    
    public var h: Int {
        return model.h ?? 0
    }
    
    public var w: Int {
        return model.w ?? 0
    }
    
    public var downloadURL: URL? {
        guard let b2Key = self.b2Key else { return nil }
        return URL(string: "https://meo.comick.pictures/\(b2Key)")
    }
}
