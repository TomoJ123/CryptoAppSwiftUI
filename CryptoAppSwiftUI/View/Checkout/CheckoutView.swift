//
//  CheckoutView.swift
//  CryptoAppSwiftUI
//
//  Created by Tomislav Jurić-Arambašić on 30.05.2022..
//

import SwiftUI
import SDWebImageSwiftUI

struct CheckoutView: View {
    @EnvironmentObject var appModel: AppViewModel
    var selectedCoin: CryptoModel
    var checkoutOption: CheckoutOption
    @State private var isDisabled: Bool = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                AnimatedImage(url: URL(string: selectedCoin.image))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                
                
                Text(checkoutOption == .buy ? "You are buying \(selectedCoin.name),\n hurry before price goes up!" : "You are selling \(selectedCoin.name),\n hurry before price goes down!")
                    .font(.system(size: 25).bold())
                
                if let portfolioCoin = appModel.currentUser?.portfolio.first(where: { $0.symbol == selectedCoin.symbol }) {
                    Text("You have \(portfolioCoin.coins) to sell")
                        .font(.body)
                } else {
                    Text("You have \(appModel.currentUser?.money ?? 0) VM avaliable")
                        .font(.body)
                }
                
                if let coin = appModel.coins?.first(where: { $0.symbol == selectedCoin.symbol}) {
                    Text("The selected coin price is: \(coin.current_price.convertToCurrency())")
                        .font(.body)
                }
                
                TextField("", text: $appModel.amount)
                    .placeholder("Enter Amount...", when: $appModel.amount.wrappedValue.isEmpty)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10.0).fill(Color("MainBackground")))
                    .overlay(RoundedRectangle(cornerRadius: 10.0).strokeBorder(checkAvailableMoney() , style: StrokeStyle(lineWidth: 2.0)))
                    .padding()
                    .foregroundColor(.black)
                
                #warning("ako je sell onda druga funk i text!")
                Text("You are getting \(calculateIncome())")
                
                Button {
                    finishTransaction()
                } label: {
                    Text(checkoutOption == .buy ? "BUY" : "SELL")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .background {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill((appModel.amount.isEmpty || !validateAmountField()) ? Color.gray : Color("BuyButton"))
                        }
                }
                .disabled(appModel.amount.isEmpty || !validateAmountField())
                .padding([.leading, .trailing], 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color("MainBackground")
            )
            .alert(isPresented: $appModel.isShowingAlert) {
                Alert(title: Text("Transaction Message!"), message: Text($appModel.alertMessage.wrappedValue), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                appModel.amount = ""
            }
        }
        .hideNavigation()
    }
    
    private func validateAmountField() -> Bool {
        if let _ = Double(appModel.amount) {
            return true
        }
        return false
    }
    
    #warning("za selanje se ovako nesmi, granat buy i sell ode")
    private func checkAvailableMoney() -> Color {
        if let availableMoney = appModel.currentUser?.money,
           let moneyToSpend = Double(appModel.amount) {
            if Double(availableMoney) >= moneyToSpend {
                return .green
            }
        }
        return .red
    }
    
    private func calculateIncome() -> String {
        if checkoutOption == .buy {
            if let coin = appModel.coins?.first(where: { $0.symbol == selectedCoin.symbol}),
               let amount = Double(appModel.amount) {
                return "\(amount / coin.current_price) \(coin.symbol)"
            }
        } else {
            
        }
        return "0 dolars"
    }
    
    private func finishTransaction() {
        if checkoutOption == .buy {
            if let coin = appModel.coins?.first(where: { $0.symbol == selectedCoin.symbol}),
               let amount = Double(appModel.amount) {
                let coinsBought = amount / coin.current_price
                let coinSymbol = coin.symbol
                
                appModel.buyTransactions(option: .buy, coinsAmount: coinsBought, symbol: coinSymbol, vMoney: amount)
            }
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(selectedCoin: CryptoModel(id: "dsmalč", symbol: "btc", name: "bitcoin", image: "https://assets.coingecko.com/coins/images/325/large/Tether-logo.png?1598003707", current_price: 52000.0, last_updated: "ndasiml", price_change: 5.412, last_7days_price: GraphModel(price: [21,312,342])), checkoutOption: .buy).environmentObject(AppViewModel())
    }
}
