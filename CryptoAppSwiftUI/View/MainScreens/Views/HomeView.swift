import SwiftUI
import SDWebImageSwiftUI

struct HomeView: View {
    
    //Shared data
    @EnvironmentObject var sharedModel: AppViewModel
    var lastSeenCoins = UserDefaults.standard.array(forKey: UserDefaultsKeys.lastSeen.rawValue)
    
    var body: some View {
        ScrollView(showsIndicators: false, content: {
            VStack(alignment: .leading) {
                Text(sharedModel.currentUser?.firstLastName ?? "Tomo Juric")
                    .font(.system(size: 20).bold())
                Text("Welcome back 👋")
                    .font(.footnote)
                    .foregroundColor(.gray)
                
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding()
            
            VStack(alignment: .center, spacing: 10) {
                Text("Current Balance")
                    .foregroundColor(.gray)
                
                if let userMoney = sharedModel.currentUser?.money {
                    Text("$ \(String(format: "%.2f", userMoney))")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                } else {
                    Text("$ 0")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .frame(height: 220)
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous).fill(Color("CurrentBalance"))
                
                Circle()
                    .strokeBorder(Color.white.opacity(0.3), lineWidth: 3)
                    .frame(width: 30, height: 30)
                    .blur(radius: 2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                    .padding(30)
                
                Circle()
                    .strokeBorder(Color.white.opacity(0.3), lineWidth: 3)
                    .frame(width: 23, height: 23)
                    .blur(radius: 2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    .padding(.leading, 30)
                
                Circle()
                    .strokeBorder(Color.white.opacity(0.3), lineWidth: 3)
                    .frame(width: 30, height: 30)
                    .blur(radius: 2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .offset(y: -50)
                    .padding(30)
                
                Circle()
                    .strokeBorder(Color.white.opacity(0.3), lineWidth: 3)
                    .frame(width: 30, height: 30)
                    .blur(radius: 2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                    .padding(30)
                
                Circle()
                    .strokeBorder(Color.white.opacity(0.3), lineWidth: 3)
                    .frame(width: 23, height: 23)
                    .blur(radius: 2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .padding(.leading, 30)
            }
            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color("White"), style: StrokeStyle(lineWidth: 2.0)))
            .padding([.leading, .trailing], 25)
            
            HStack() {
                Text("My Portfolio")
                    .font(.system(size: 20).bold())
                
                Spacer()
                
                Text("View all")
                    .font(.system(size: 15))
                    .foregroundColor(Color("CurrentBalance"))
            }
            .padding(.top, 20)
            .padding([.leading, .trailing], 10)
            
            Group {
                // Portfolio read from db
                if let portfolio = sharedModel.currentUser?.portfolio, !portfolio.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(portfolio, id: \.symbol) { coin in
                                makeMyPortfolioCoinView(coin: coin)
                            }
                        }
                    }
                    .padding(.leading, 15)
                } else {
                    Text("You dont have any coins\n in the portfolio. Buy some!")
                        .padding()
                        .foregroundColor(.gray)
                }
            }
            
            Text("Last seen")
                .font(.system(size: 20).bold())
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 20)
                .padding([.leading, .trailing], 10)
            
            Group {
                if let lastSeen = lastSeenCoins as? [String] {
                    ForEach(lastSeen, id: \.self) { coin in
                        if let apiCoin = sharedModel.coins?.first(where: {$0.symbol == coin}) {
                            makeLastSeenCoinView(coin: apiCoin)
                        }
                    }
                } else {
                    if let coins = sharedModel.coins?.prefix(5) {
                        let symbols = coins.map({ $0.symbol })
                        let _ = UserDefaults.standard.set(symbols, forKey: UserDefaultsKeys.lastSeen.rawValue)
                        
                        ForEach(coins, id: \.id) { coin in
                            makeLastSeenCoinView(coin: coin)
                        }
                    }
                }
            }
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("MainBackground"))
    }
    
    private func saveRandomCoins(symbols: [String]) {
        UserDefaults.standard.set(symbols, forKey: UserDefaultsKeys.lastSeen.rawValue)
    }
    
    @ViewBuilder
    private func makeMyPortfolioCoinView(coin: PortfolioModel) -> some View {
        HStack() {
            VStack() {
                Text("\(sharedModel.coins?.first(where: { $0.symbol == coin.symbol })?.name ?? "")")
                    .font(.system(size: 18).bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(coin.symbol.uppercased())")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Text("\(sharedModel.coins?.first(where: { $0.symbol == coin.symbol})?.current_price.convertToCurrency() ?? "")")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 20).bold())
            }
            
            Spacer()
            
            VStack() {
                AnimatedImage(url: URL(string: sharedModel.coins?.first(where: { $0.symbol == coin.symbol})?.image ?? ""))
                    .resizable()
                    .frame(width: 50, height: 50,alignment: .leading)
                
                Spacer()
                
                Text(calculateProfit(boughtPrice: coin.currentPrice, currentPrice: sharedModel.coins?.first(where: { $0.symbol == coin.symbol})?.current_price))
                    .foregroundColor(checkProfitOrLoss(boughtPrice: coin.currentPrice, currentPrice: sharedModel.coins?.first(where: { $0.symbol == coin.symbol})?.current_price))
            }
        }
        .padding()
        .frame(width: 200, height: 140)
        .background {
            RoundedRectangle(cornerRadius: 20, style: .continuous).fill(Color("White"))
        }
    }
    
    func checkProfitOrLoss(boughtPrice: Double, currentPrice: Double?) -> Color {
        if let currentPrice = currentPrice {
            return boughtPrice > currentPrice ? .red : .green
        }
        return .red
    }
    
    func calculateProfit(boughtPrice: Double, currentPrice: Double?) -> String {
        if let currentPrice = currentPrice {
            let difference = currentPrice - boughtPrice
            let profit = difference / currentPrice
            let profitPercentage = profit * 100
            
            let result = String(format: "%.2f", profitPercentage)
            return result + "%"
        } else {
            return "2.35%"
        }
    }
    
    @ViewBuilder
    private func makeLastSeenCoinView(coin: CryptoModel) -> some View {
        HStack() {
            AnimatedImage(url: URL(string: coin.image))
                .resizable()
                .frame(width: 50, height: 50,alignment: .leading)
                .padding(.trailing, 15)
            
            VStack() {
                Text(coin.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 18).bold())
                
                Text(coin.symbol.uppercased())
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(width: 90)
            
            Spacer()
            
            VStack() {
                Text(coin.current_price.convertToCurrency())
                    .font(.system(size: 18).bold())
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Text(String(format: "%.2f", coin.price_change) + "%")
                    .foregroundColor(coin.price_change.isNegativeValue ? .red : .green)
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color("White"))
        }
        .padding([.leading, .trailing], 15)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(AppViewModel())
    }
}
