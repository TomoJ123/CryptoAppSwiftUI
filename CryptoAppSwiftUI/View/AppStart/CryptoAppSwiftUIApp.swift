//
//  CryptoAppSwiftUIApp.swift
//  CryptoAppSwiftUI
//
//  Created by Tomislav Jurić-Arambašić on 15.04.2022..
//

import SwiftUI
import Firebase

@main
struct CryptoAppSwiftUIApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
