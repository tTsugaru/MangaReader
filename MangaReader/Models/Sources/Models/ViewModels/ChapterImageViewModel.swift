//
//  ChapterImageViewModel.swift
//  Models
//
//  Created by Jakub Gencer on 01.03.25.
//

import Foundation

public struct ChapterImageViewModel {
    private let model: ChapterImage
    
    public init(model: ChapterImage) {
        self.model = model
    }
    
    public var url: URL? {
        if let b2Key = model.b2Key {
            return URL(string: "https://meo.comick.pictures/\(b2Key)")
        }
        
        if let url = model.url {
            return URL(string: url)
        }
        
        return nil
    }
    
    public var width: Int {
        return model.width
    }
    
    public var height: Int {
        return model.height
    }
    
    public var mangaSlug: String?
}
