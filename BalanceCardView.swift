//
//  BalanceCardView.swift
//  ExpenseTrackerApp
//
//  Created by Noman belim on 05/02/26.
//

import Foundation
import SwiftUI

struct BalanceCardView: View {
    
    let total: Double
    let income: Double
    let expense: Double
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Total Balance")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text(" ₹ \(total, specifier: "%.2f")")
                .font(.largeTitle)
                .bold()
                .foregroundColor(total >= 0 ? .green : .red)
            
            HStack(spacing: 40) {
                info("Income", income, .green)
                info("Expense", expense, .red)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8)
        .padding()
    }
    
    func info(_ title: String, _ value: Double, _ color: Color) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(" ₹ \(value, specifier: "%.2f")")
                .font(.title3)
                .bold()
                .foregroundColor(color)
        }
    }
}

#Preview {
    BalanceCardView(total: 2500, income: 3000, expense: 500)
}
