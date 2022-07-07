import Foundation

struct User: Codable, Equatable {
    var firstLastName: String
    var money: Double
    var email: String
    var portfolio: [PortfolioModel]
    var transactions: [TransactionModel]
}

struct PortfolioModel: Codable, Equatable {
    var symbol: String
    var virtualAmount: Double
    var coins: Double
    var currentPrice: Double
}

struct TransactionModel: Codable, Equatable {
    var transactionType: TransactionType
    var symbol: String
    var virtualAmount: Double
    var coinsTransfered: Double
    var date: Date
}

enum TransactionType: Codable, Equatable {
    case bought
    case sold
}


extension User: JsonParser {
    typealias T = User
    
    func toDict() -> [String : Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else { return nil }
        return json
    }
    
    static func toObject(dict: [String : Any]) -> User? {
        do {
            let json = try JSONSerialization.data(withJSONObject: dict)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedObject = try decoder.decode(T.self, from: json)
            return decodedObject
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
