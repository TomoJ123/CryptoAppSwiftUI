//
//  SettingsView.swift
//  CryptoAppSwiftUI
//
//  Created by Tomislav Jurić-Arambašić on 19.05.2022..
//

import SwiftUI
import Firebase

struct SettingsView: View {
    
    var body: some View {
        VStack() {
            Text("2")
            Button {
                do {
                    try Auth.auth().signOut()
                } catch {
                    
                }
                
            } label: {
                Text("LOGOUT")
            }
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
