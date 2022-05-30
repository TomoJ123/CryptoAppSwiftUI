//
//  SplashView.swift
//  CryptoAppSwiftUI
//
//  Created by Tomislav Jurić-Arambašić on 24.04.2022..
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack() {
            LottieView(name: "CryptoSplash", loopMode: .loop)
                .frame(width: 400, height: 400, alignment: .center)
            
            Text("CRYPTIO")
                .font(.largeTitle.bold())
                .shadow(radius: 10)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color("MainBackground")
        )
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
