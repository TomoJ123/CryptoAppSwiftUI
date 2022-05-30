import SwiftUI
import SDWebImageSwiftUI

struct CryptoDetailsView: View {
    @State private var currentCoin = "BTC"
    @Namespace var animation
    @EnvironmentObject var appModel: AppViewModel
    @State private var isClicked: Bool = false
    @State private var optionClicked: CheckoutOption? = nil
    var selectedCoin: CryptoModel
    var athPrices: [String: String] = ["BTC" : "$68,990.90",
                                       "ETH" : "$4,865.57",
                                       "USDT" : "$1.22",
                                       "USDC" : "$2.35",
                                       "BNB" : "$690.93",
                                       "XRP" : "$3.84",
                                       "BUSD" : "$1.11",
                                       "ADA" : "$3.10",
                                       "SOL" : "$259.99",
                                       "DOGE" : "$0.74"]
    
    var body: some View {
        NavigationView {
            VStack {
                // MARK: Sample UI
                HStack(spacing: 15) {
                    AnimatedImage(url: URL(string: selectedCoin.image))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(selectedCoin.name)
                            .font(.callout)
                        Text(selectedCoin.symbol.uppercased())
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 5) {
                        Text("All time high")
                            .font(.callout)
                        
                        if let ath = athPrices[selectedCoin.symbol.uppercased()] {
                            Text(ath)
                        } else {
                            Text("$529.1")
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                //                    CustomControl(coins: coins)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(selectedCoin.current_price.convertToCurrency())
                        .font(.largeTitle.bold())
                    
                    // MARK: Profit/Loss
                    Text("\(selectedCoin.price_change > 0 ? "+" : "")\(String(format: "%.2f", selectedCoin.price_change))")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(selectedCoin.price_change < 0 ? .white : .black)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(selectedCoin.price_change < 0 ? .red : .green)
                        )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                GraphView(coin: selectedCoin)
                
                Controls()
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color("MainBackground")
            )
            .hideNavigation()
        }
    }
    
    //MARK: Custom segmented control
    @ViewBuilder
    func CustomControl(coins: [CryptoModel]) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(coins) { coin in
                    Text(coin.symbol.uppercased())
                        .foregroundColor(currentCoin == coin.symbol.uppercased() ? .white : .gray)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .contentShape(Rectangle())
                        .background {
                            if currentCoin == coin.symbol.uppercased() {
                                Rectangle()
                                    .fill(Color(.systemGray5))
                                    .matchedGeometryEffect(id: "SEGMENTEDTAB", in: animation)
                            }
                        }
                        .onTapGesture {
                            appModel.currentCoin = coin
                            withAnimation {
                                currentCoin = coin.symbol.uppercased()
                            }
                        }
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            }
            .padding(.vertical)
        }
    }
    
    // MARK: Line graph
    @ViewBuilder
    func GraphView(coin: CryptoModel) -> some View {
        GeometryReader { _ in
            LineGraph(data: coin.last_7days_price.price, profit: coin.price_change > 0)
        }
        .padding(.vertical, 30)
        .padding(.bottom, 20)
    }
    
    // MARK: Controls
    @ViewBuilder
    func Controls() -> some View {
        HStack(spacing: 20) {
            if let portfolioCoin = appModel.currentUser?.portfolio.contains(where: { $0.symbol.uppercased() == selectedCoin.symbol.uppercased() }), portfolioCoin {
                NavigationLink(destination: CheckoutView(selectedCoin: selectedCoin, checkoutOption: optionClicked ?? .buy).environmentObject(appModel), isActive: $isClicked) {
                    Button {
                        optionClicked = .sell
                        isClicked = true
                    } label: {
                        Text("Sell")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .background {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(.white)
                            }
                    }
                }
                .hideNavigation()
                
                NavigationLink(destination: CheckoutView(selectedCoin: selectedCoin, checkoutOption: optionClicked ?? .buy).environmentObject(appModel), isActive: $isClicked) {
                    Button {
                        optionClicked = .buy
                        isClicked = true
                    } label: {
                        Text("Buy")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .background {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color("BuyButton"))
                            }
                    }
                }
                .hideNavigation()
            } else {
                NavigationLink(destination: CheckoutView(selectedCoin: selectedCoin, checkoutOption: optionClicked ?? .buy).environmentObject(appModel), isActive: $isClicked) {
                    Button {
                        optionClicked = .buy
                        isClicked = true
                    } label: {
                        Text("Buy")
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                            .background {
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color("BuyButton"))
                            }
                    }
                }
                .hideNavigation()
            }
        }
    }
}

struct CryptoDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
