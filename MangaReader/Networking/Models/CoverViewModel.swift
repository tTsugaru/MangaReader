import Foundation

struct CoverViewModel {
    private let model: Cover
    
    init(model: Cover) {
        self.model = model
    }
    
    var b2Key: String? {
        return model.b2key
    }
    var h: Int {
        return model.h ?? 0
    }
    var w: Int {
        return model.w ?? 0
    }
    
    var downloadURL: URL? {
        guard let b2Key = self.b2Key else { return nil }
        return URL(string: "https://meo.comick.pictures/\(b2Key)")
    }
}
