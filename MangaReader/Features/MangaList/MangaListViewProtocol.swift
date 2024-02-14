import Foundation

@MainActor
protocol MangaListViewProtocol {
    var slug: String { get }
    var title: String { get }
    var imageDownloadURL: URL? { get }
}
