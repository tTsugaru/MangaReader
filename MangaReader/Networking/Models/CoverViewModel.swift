import Foundation

struct CoverViewModel {
    private let model: Cover
    
    init(model: Cover) {
        self.model = model
    }
    
    var b2Key: String {
        return model.b2key
    }
    var h: Int {
        return model.h
    }
    var w: Int {
        return model.w
    }
    
    var downloadURL: URL? {
        return URL(string: "https://meo.comick.pictures/\(self.b2Key)")
    }
}
