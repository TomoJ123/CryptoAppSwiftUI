//
//  ContentView.swift
//  CryptoAppSwiftUI
//
//  Created by Tomislav Jurić-Arambašić on 15.04.2022..
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State var isSplashFinished = false
    @State var isLoggedIn = false
    
    var body: some View {
        loggedInState(isLoggedIn: $isLoggedIn)
            .preferredColorScheme(.light)
            .overlay(
                SplashView()
                    .opacity(isSplashFinished ? 0 : 1)
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                    isSplashFinished = true
                })
            }
    }
}

@ViewBuilder
func loggedInState(isLoggedIn: Binding<Bool>) -> some View {
    if Auth.auth().currentUser?.uid != nil || isLoggedIn.wrappedValue {
        MainView(isLoggedIn: isLoggedIn)
    } else {
        LoginView(isLoggedIn: isLoggedIn, loginData: LoginViewModel(loginService: FirebaseService()))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
