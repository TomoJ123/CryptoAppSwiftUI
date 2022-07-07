//
//  TransactionHIstoryView.swift
//  CryptoAppSwiftUI
//
//  Created by Tomislav Jurić-Arambašić on 30/10/38 ERA1.
//

import SwiftUI

struct TransactionHIstoryView: View {
    var sharedData: AppViewModel
    
    var body: some View {
        ZStack {
            Color("MainBackground").edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(sharedData.currentUser?.transactions.reversed() ?? [], id: \.date) { transaction in
                    makeTransactionCell(transaction: transaction)
                }
            }
        }
    }
    
    @ViewBuilder
    private func makeTransactionCell(transaction: TransactionModel) -> some View {
        HStack() {
            VStack() {
                Text(transaction.symbol.uppercased())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 18).bold())
                    .foregroundColor(.black)
                
                Text(String(format: "%.2f", transaction.virtualAmount) + "VM")
                    .foregroundColor(.gray)
                    .font(.system(size: 15))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(width: 90)
            
            Spacer()
            
            VStack() {
                Text(String(format: "%.2f", transaction.coinsTransfered) + "Coins")
                    .font(.system(size: 18).bold())
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(.black)
                Text(transaction.transactionType == .bought ? "BOUGHT" : "SOLD")
                    .foregroundColor(transaction.transactionType == .bought ? .green : .red)
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

struct TransactionHIstoryView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionHIstoryView(sharedData: AppViewModel())
    }
}
