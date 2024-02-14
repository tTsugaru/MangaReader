import Foundation

struct Config {
    static let defaultsKey = "MangaReader"
    
    @UserDefaultsWrapper(key: Config.defaultsKey + "mangaReadStates", defaultValue: [])
    static var mangaReadStates: [MangaReadState]
}
