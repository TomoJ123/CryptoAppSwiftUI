import SwiftUI
import SDWebImageSwiftUI

struct MarketView: View {
    
    //Shared data
    @EnvironmentObject var sharedModel: AppViewModel
    @State private var openDetails: Bool = false
    @State private var selectedCoin: CryptoModel? = nil
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack() {
                    Text("MARKET 📉")
                        .font(.system(size: 20).bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Buy quickly before they go up!")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                
                ForEach(sharedModel.coins ?? []) { coin in
                    NavigationLink(destination: CryptoDetailsView(selectedCoin: selectedCoin ?? coin).environmentObject(sharedModel), isActive: $openDetails) {
                        Button {
                            self.selectedCoin = coin
                            openDetails = true
                        } label: {
                            makeLastSeenCoinView(coin: coin)
                        }
                    }
                    .hideNavigation()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("MainBackground"))
        }
        .hideNavigation()
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
                    .foregroundColor(.black)
                
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
                    .foregroundColor(.black)
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

struct MarketView_Previews: PreviewProvider {
    static var previews: some View {
        MarketView()
    }
}
