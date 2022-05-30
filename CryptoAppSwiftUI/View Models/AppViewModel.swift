import SwiftUI
import Combine

class AppViewModel: ObservableObject {
    @Published var coins: [CryptoModel]?
    @Published var currentCoin: CryptoModel?
    @Published var currentUser: User?
    var fetchingTimer: Timer?
    
    @Published var isShowingAlert: Bool = false
    @Published var alertMessage: String = ""
    
    // Buying or selling amount
    @Published var amount: String = ""
    
    var firebaseService = FirebaseService()
    
    init() {
        fetchData()
        fetchingTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(fetchCryptoWithTimer), userInfo: nil, repeats: true)
        
        
        if let userMail = UserDefaults.standard.string(forKey: UserDefaultsKeys.mail.rawValue) {
            firebaseService.getUser(email: userMail) { [weak self] user in
                if let user = user {
                    self?.currentUser = user
                }
            }
        }
    }
    
    // MARK: Fetching Crypto Data
    private func fetchCryptoData() async throws {
        guard let url = url else { return }
        let session = URLSession.shared
        
        let response = try await session.data(from: url)
        let jsonData = try JSONDecoder().decode([CryptoModel].self, from: response.0)
        
        await MainActor.run(body: {
            self.coins = jsonData
            
            if let firstCoin = jsonData.first {
                self.currentCoin = firstCoin
            }
        })
    }
    
    @objc func fetchCryptoWithTimer() {
        fetchData()
    }
    
    private func fetchData() {
        Task {
            do {
                try await fetchCryptoData()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func buyTransactions(option: CheckoutOption, coinsAmount: Double, symbol: String, vMoney: Double) {
        let portfolioModel = PortfolioModel(symbol: symbol, virtualAmount: vMoney, coins: coinsAmount)
        let transactionModel = TransactionModel(transactionType: .bought, virtualAmount: vMoney, coinsBought: coinsAmount, date: Date.now)
        
        firebaseService.updateBuyOptionUserData(portfolio: portfolioModel, transaction: transactionModel, userMail: currentUser!.email) { [weak self] isSaved , message in
            
            guard let self = self else { return }
            
            if let user = isSaved {
                self.currentUser = user
                self.alertMessage = message
            } else {
                self.alertMessage = message
            }
            
            self.isShowingAlert = true
        }
    }
}
