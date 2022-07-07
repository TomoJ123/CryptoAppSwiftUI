//
//  PieChartView.swift
//  CryptoAppSwiftUI
//
//  Created by Tomislav Jurić-Arambašić on 30/10/38 ERA1.
//

import SwiftUI
import SwiftPieChart

struct CryptoPieChartView: View {
    var chartData: [Double]
    var chartSymbols: [String]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            PieChartView(values: chartData, names: chartSymbols, formatter: { value in String(format: "$%.2f", value)}, colors: [.red, .blue, .green, .purple, .orange, .yellow, .cyan, .indigo, .pink, .brown, .mint, .teal, .clear, .secondary], backgroundColor: Color.black, widthFraction: 0.80)
        }
        .padding([.leading, .trailing], 10)
        .background(
            Color.black
        )
    }
}

struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        CryptoPieChartView(chartData: [20], chartSymbols: ["tomo"])
    }
}
