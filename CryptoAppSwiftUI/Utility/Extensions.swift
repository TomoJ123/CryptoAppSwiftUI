//
//  CurrencyConverter.swift
//  CryptoAppSwiftUI
//
//  Created by Tomislav Jurić-Arambašić on 24.04.2022..
//

import SwiftUI

extension Double {
    func convertToCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        
        return formatter.string(from: .init(value: self)) ?? ""
    }
    
    var isNegativeValue: Bool {
        return self.description.starts(with: "-")
    }
}

extension View {
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
    
    func placeholder<Content: View>(
            when shouldShow: Bool,
            alignment: Alignment = .leading,
            @ViewBuilder placeholder: () -> Content) -> some View {

            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
    
    func placeholder(
           _ text: String,
           when shouldShow: Bool,
           alignment: Alignment = .leading) -> some View {
               
           placeholder(when: shouldShow, alignment: alignment) { Text(text).foregroundColor(Color(uiColor: .systemGray)) }
       }
}

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .scale.combined(with: .opacity))
    }
}
