import Foundation

@propertyWrapper
struct UserDefaultsWrapper<Value: Codable> {
    let key: String
    let defaultValue: Value
    let userDefaults = UserDefaults.standard
    
    var wrappedValue: Value {
        get {
            let data = userDefaults.data(forKey: key)
            let value = data.flatMap { try? JSONDecoder().decode(Value.self, from: $0) }
            return value ?? defaultValue
        }
        
        set {
            let data = try? JSONEncoder().encode(newValue)
            userDefaults.set(data, forKey: key)
            userDefaults.synchronize()
        }
    }
}
