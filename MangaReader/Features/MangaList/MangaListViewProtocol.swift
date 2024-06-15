import Foundation

protocol MangaListViewProtocol: Sendable {
    var slug: String { get }
    var title: String { get }
    var imageDownloadURL: URL? { get }
}
