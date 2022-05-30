//
//  MainView.swift
//  CryptoAppSwiftUI
//
//  Created by Tomislav Jurić-Arambašić on 19.05.2022..
//

import SwiftUI

struct MainView: View {
    
    @State var currentTab: Tab = .home
    
    @StateObject var sharedData: AppViewModel = AppViewModel()
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            TabView(selection: $currentTab) {
                
                HomeView()
                    .environmentObject(sharedData)
                    .tag(Tab.home)
                
                MarketView()
                    .environmentObject(sharedData)
                    .tag(Tab.market)
                
                SettingsView()
                    .tag(Tab.settings)
            }
            
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    
                    Button {
                        currentTab = tab
                    } label: {
                        Image(tab.rawValue)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 22, height: 22)
                            .background(
                                Color.blue
                                    .opacity(0.1)
                                    .cornerRadius(5)
                                    .blur(radius: 5)
                                    .padding(-7)
                                    .opacity(currentTab == tab ? 1 : 0)
                            )
                            .frame(maxWidth: .infinity)
                            .foregroundColor(currentTab == tab ? Color.blue : Color.black.opacity(0.3))
                    }
                }
            }
            .padding([.horizontal, .top])
            .padding(.bottom, 10)
        }
        .background(Color("White").ignoresSafeArea())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


//Tab cases
enum Tab: String, CaseIterable {
    
    case home = "Home"
    case market = "Market"
    case settings = "Settings"
}
