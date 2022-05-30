protocol JsonParser {
    associatedtype T
    
    func toDict() -> [String: Any]?
    static func toObject(dict: [String: Any]) -> T?
}
