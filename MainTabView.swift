//
//  MainTabView.swift
//  ExpenseTrackerApp
//
//  Created by Noman belim on 05/02/26.
//

import Foundation
import SwiftUI



struct MainTabView: View {

    var body: some View {
        TabView {

            DashboardView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Stats")
                }

            AddExpenseView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }
        }
    }
}

struct AppColors {
    static let primary = Color(hex: "#5F8F87")
    static let background = Color.white
    static let income = Color.green
    static let expense = Color.red
}

import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var vm: TransactionViewModel

    var body: some View {

        NavigationStack {
            ScrollView {

                VStack(spacing: 24) {

                    // MARK: - Profile Header
                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 90, height: 90)
                            .foregroundColor(.gray)

                        Text("Noman Belim")
                            .font(.title2)
                            .bold()

                        Text("nomanbelim@email.com")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.top)

                    // MARK: - Summary Cards
                    HStack(spacing: 16) {

                        summaryCard(
                            title: "Income",
                            amount: vm.totalIncome,
                            color: .green
                        )

                        summaryCard(
                            title: "Expense",
                            amount: vm.totalExpense,
                            color: .red
                        )
                    }
                    .padding(.horizontal)

                    // MARK: - Options List
                    VStack(spacing: 12) {

                        profileRow(
                            icon: "folder.fill",
                            title: "Categories"
                        )

                        profileRow(
                            icon: "chart.bar.fill",
                            title: "Statistics"
                        )

                        profileRow(
                            icon: "square.and.arrow.up.fill",
                            title: "Export Data"
                        )

                        profileRow(
                            icon: "questionmark.circle.fill",
                            title: "Help & Support"
                        )

                        profileRow(
                            icon: "arrow.backward.square.fill",
                            title: "Logout",
                            isDestructive: true
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom, 40)
            }
            .navigationTitle("Profile")
        }
    }

    // MARK: - Summary Card
    private func summaryCard(
        title: String,
        amount: Double,
        color: Color
    ) -> some View {

        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)

            Text(String(format: " ₹ %.2f", amount))
                .bold()
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.05), radius: 6)
    }

    // MARK: - Profile Row
    private func profileRow(
        icon: String,
        title: String,
        isDestructive: Bool = false
    ) -> some View {

        HStack {
            Image(systemName: icon)
                .foregroundColor(isDestructive ? .red : .blue)
                .frame(width: 24)

            Text(title)
                .foregroundColor(isDestructive ? .red : .primary)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.05), radius: 6)
    }
}

// Profile Row Component
struct ProfileRow: View {
    let icon: String
    let title: String
    let value: String
    var color: Color = AppColors.primary
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
            
            Text(title)
            
            Spacer()
            
            Text(value)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(TransactionViewModel())
}
