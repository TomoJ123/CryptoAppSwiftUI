//
//  SettingsView.swift
//  CryptoAppSwiftUI
//
//  Created by Tomislav Jurić-Arambašić on 19.05.2022..
//

import SwiftUI
import Firebase

struct SettingsView: View {
    @EnvironmentObject var sharedModel: AppViewModel
    
    @State private var showAlert = false
    @State private var isLoggingOut = false
    
    @Binding var isLoggedOut: Bool
    
    @State var chartVM: [Double] = []
    @State var chartSymbols: [String] = []
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                CustomNavigationLink(title: "Pie chart") {
                    CryptoPieChartView(chartData: chartVM, chartSymbols: chartSymbols)
                }
                CustomNavigationLink(title: "Leaderboard") {
                    LeaderboardView()
                }
                CustomNavigationLink(title: "Transaction history") {
                    TransactionHIstoryView(sharedData: sharedModel)
                }
                
                HStack {
                    Text("Logout")
                        .font(.system(size: 17))
                        .foregroundColor(Color.black)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                }
                .foregroundColor(.black)
                .padding()
                .background(
                    Color("MainBackground")
                        .cornerRadius(12)
                )
                .onTapGesture {
                    showAlert = true
                }
                .padding(.horizontal)
                .padding(.top, 10)
            }
            .onAppear {
                calculateChartData()
            }
            .overlay {
                if isLoggingOut {
                    ProgressView()
                        .frame(width: 50, height: 50, alignment: .center)
                        .background(Color.gray)
                        .cornerRadius(10)
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("You sure you want to logout?"), message: Text(""), primaryButton: .default(Text("OK")) {
                    do {
                        isLoggingOut = true
                        try Auth.auth().signOut()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation(.easeInOut) {
                                isLoggedOut = true
                                isLoggingOut = false
                            }
                        }
                        } catch {}
                }, secondaryButton: .cancel())
            }
            .navigationTitle(Text("Settings"))
        }
    }
    
    private func calculateChartData() {
        chartVM.removeAll()
        chartSymbols.removeAll()
        
        sharedModel.currentUser?.portfolio.forEach({ model in
            chartVM.append(model.virtualAmount)
            chartSymbols.append(model.symbol.uppercased())
        })
    }
    
    @ViewBuilder
    func CustomNavigationLink<Detail: View>(title: String, @ViewBuilder content: @escaping () -> Detail) -> some View {
        
        NavigationLink {
            content()
        } label: {
            
            HStack {
                Text(title)
                    .font(.system(size: 17))
                    .foregroundColor(Color.black)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Image(systemName: "chevron.right")
            }
            .foregroundColor(.black)
            .padding()
            .background(
                
                Color("MainBackground")
                    .cornerRadius(12)
            )
            .padding(.horizontal)
            .padding(.top, 10)
        }
    }
}
