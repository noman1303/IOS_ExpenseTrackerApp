//
//  DashboardView.swift
//  ExpenseTrackerApp
//
//  Created by Noman belim on 05/02/26.
//

import SwiftUI

import SwiftUI

struct DashboardView: View {

    @EnvironmentObject var vm: TransactionViewModel

    var body: some View {

        ZStack(alignment: .top) {

            Color.white
                .ignoresSafeArea()

            // Top green background
            VStack {
                Color(hex: "#5F8F87")
                    .frame(height: 320)
                Spacer()
            }
            .ignoresSafeArea(edges: .top)

            ScrollView(showsIndicators: false) {

                VStack(spacing: 24) {

                    // MARK: - Header
                    headerView
                        .padding(.top, 60)

                    // MARK: - Balance Card
                    balanceCard

                    // MARK: - Transactions
                    transactionsSection
                }
                .padding(.top, 80)
                .padding(.bottom, 40)
            }
        }
    }

    // MARK: - Header View
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Good afternoon,")
                    .foregroundColor(.white.opacity(0.8))

                Text("Noman Belim")
                    .foregroundColor(.white)
                    .font(.title2)
                    .bold()
            }

            Spacer()

            Image(systemName: "bell")
                .foregroundColor(.white)
                .padding()
                .background(Color.white.opacity(0.15))
                .clipShape(Circle())
        }
        .padding(.horizontal)
    }

    // MARK: - Balance Card
    private var balanceCard: some View {
        VStack(spacing: 20) {

            VStack(alignment: .leading, spacing: 8) {
                Text("Total Balance")
                    .foregroundColor(.white.opacity(0.8))

                Text(formattedAmount(vm.totalBalance))
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
            }

            HStack {
                balanceItem(
                    title: "Income",
                    amount: vm.totalIncome,
                    color: .green
                )

                Spacer()

                balanceItem(
                    title: "Expense",
                    amount: vm.totalExpense,
                    color: .red
                )
            }
        }
        .padding()
        .background(Color(hex: "#5F8F87"))
        .clipShape(RoundedRectangle(cornerRadius: 28))
        .shadow(color: .black.opacity(0.15), radius: 20, y: 10)
        .padding(.horizontal)
    }

    // MARK: - Transactions Section
    private var transactionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {

            HStack {
                Text("Transactions History")
                    .font(.headline)

                Spacer()

                Text("See all")
                    .foregroundColor(.gray)
            }

            ForEach(vm.transactions) { item in
                TransactionRowView(transaction: item)
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Helpers
    private func formattedAmount(_ value: Double) -> String {
        return String(format: " ₹ %.2f", value)
    }

    private func balanceItem(
        title: String,
        amount: Double,
        color: Color
    ) -> some View {

        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .foregroundColor(.white.opacity(0.8))

            Text(formattedAmount(amount))
                .foregroundColor(color)
                .bold()
        }
    }
}

// Balance Item Component
struct BalanceItem: View {
    let icon: String
    let title: String
    let amount: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: icon)
                Text(title)
            }
            .foregroundColor(.white.opacity(0.8))
            
            Text(amount)
                .foregroundColor(.white)
                .bold()
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(TransactionViewModel())
}
