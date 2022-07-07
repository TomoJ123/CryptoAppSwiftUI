//
//  LeaderboardView.swift
//  CryptoAppSwiftUI
//
//  Created by Tomislav Jurić-Arambašić on 1/11/38 ERA1.
//

import SwiftUI
import Firebase

struct LeaderboardView: View {
    @State private var users: [User] = []
    @State private var isLoading: Bool = true
    
    var body: some View {
        NavigationView {
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(users.indices, id: \.self) { index in
                    makeLeaderboardCell(user: self.users[index], position: index)
                }
            }
            .overlay {
                if isLoading {
                    ProgressView()
                        .frame(width: 50, height: 50, alignment: .center)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
            .onAppear {
                FirebaseService.shared.getAllUsers { userList in
                    if let userList = userList {
                        users = userList
                        sortUsers()
                    } else {
                        users = []
                    }
                    isLoading = false
                }
            }
            .background(
                Color("MainBackground")
            )
            .hideNavigation()
        }
    }
    
    private func sortUsers() {
        users.sort { first, second in
            var firstPortfolioValue: Double = 0
            var secondPortfolioValue: Double = 0
            
            first.portfolio.forEach { coin in
                firstPortfolioValue += coin.virtualAmount
            }
            second.portfolio.forEach { coin in
                secondPortfolioValue += coin.virtualAmount
            }
            
            return firstPortfolioValue > secondPortfolioValue
        }
    }
    
    private func calculatePortfolioValue(userPortfolio: [PortfolioModel]) -> String {
        var portfolioValue: Double = 0
        
        userPortfolio.forEach { coin in
            portfolioValue += coin.virtualAmount
        }
        
        return String(format: "%.2f", portfolioValue)
    }
    
    @ViewBuilder
    private func makeLeaderboardCell(user: User, position: Int) -> some View {
        HStack() {
            VStack() {
                Text(String(position + 1) + ".")
                    .fontWeight(.bold)
                    .overlay(
                        Circle()
                            .strokeBorder(position == 0 ? Color(red: 255, green: 215, blue: 0) : .black, lineWidth: 3)
                            .frame(width: 50, height: 50)
                            .foregroundColor(.red)
                    )
            }
            .frame(width: 90)
            
            VStack() {
                Text(user.firstLastName)
                    .font(.system(size: 18).bold())
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(.black)
                Text(calculatePortfolioValue(userPortfolio: user.portfolio))
                    .foregroundColor(position == 0 ? .green : .black)
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background {
            RoundedRectangle(cornerRadius: 10, style: .continuous).fill(Color.white)
        }
        .padding([.leading, .trailing], 15)
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
