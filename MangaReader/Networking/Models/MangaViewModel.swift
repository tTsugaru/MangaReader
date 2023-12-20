import Foundation
import SwiftUI
import Kingfisher

@MainActor
class MangaViewModel: ObservableObject {
    let model: Manga

    init(model: Manga) {
        self.model = model
    }

    var id: Int {
        model.id
    }

    var hid: String {
        model.hid
    }

    var slug: String {
        model.slug
    }

    var title: String {
        model.title
    }

    var mdCovers: [Cover]? {
        model.covers
    }

    var imageDownloadURL: URL? {
        guard let imageId = mdCovers?.first?.b2key else { return nil }
        return URL(string: "https://meo.comick.pictures/\(imageId)")
    }
}

extension MangaViewModel: Hashable {
    static func == (lhs: MangaViewModel, rhs: MangaViewModel) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
