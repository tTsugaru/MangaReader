import Foundation
import SwiftUI
import Utility

public final class MangaViewModel: MangaListViewProtocol {
    let model: Manga

    public init(model: Manga) {
        self.model = model
    }

    public var id: Int {
        model.id
    }

    public var hid: String {
        model.hid
    }

    public var slug: String {
        model.slug
    }

    public var title: String {
        model.title
    }

    public var mdCovers: [Cover]? {
        model.covers
    }

    public var imageDownloadURL: URL? {
        guard let imageId = mdCovers?.first?.b2key else { return nil }
        return URL(string: "https://meo.comick.pictures/\(imageId)")!
    }
}

extension MangaViewModel: Hashable {
    public static func == (lhs: MangaViewModel, rhs: MangaViewModel) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
