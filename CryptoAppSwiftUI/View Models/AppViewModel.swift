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
    
    func buyTransactions(coinsAmount: Double, symbol: String, vMoney: Double, boughtAt: Double) {
        let portfolioModel = PortfolioModel(symbol: symbol, virtualAmount: vMoney, coins: coinsAmount, currentPrice: boughtAt)
        let transactionModel = TransactionModel(transactionType: .bought, symbol: symbol,virtualAmount: vMoney, coinsTransfered: coinsAmount, date: Date.now)
        
        if let email = currentUser?.email {
            firebaseService.updateBuyOptionUserData(portfolio: portfolioModel, transaction: transactionModel, userMail: email) { [weak self] isSaved , message in
                
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
    
    func sellTransaction(coinsAmount: Double, symbol: String, vMoney: Double, soldAt: Double) {
        // coins sold treba za transakciju, napravit isto kao ovo gore update i oduzet tamo pare, rjesit to i na prvom screenu
        // onda settings pie napravit, transaction history, leaderBoard ko ima najvise para, logout
        let portfolioModel = PortfolioModel(symbol: symbol, virtualAmount: vMoney, coins: coinsAmount, currentPrice: soldAt)
        let transactionModel = TransactionModel(transactionType: .sold, symbol: symbol, virtualAmount: vMoney, coinsTransfered: coinsAmount, date: Date.now)
        
        if let email = currentUser?.email {
            firebaseService.updateSoldOptionUserData(portfolio: portfolioModel, transaction: transactionModel, userMail: email) { [weak self] isSaved, message in
                
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
}
