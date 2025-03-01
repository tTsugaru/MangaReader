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
        } else if let url = model.url {
            return URL(string: url)
        } else {
            return nil
        }
    }
    
    public var width: Int {
        return model.w
    }
    
    public var height: Int {
        return model.h
    }
    
    public var mangaSlug: String?
}
