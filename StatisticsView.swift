//
//  StatisticsView.swift
//  ExpenseTrackerApp
//
//  Created by Noman belim on 05/02/26.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    
    @EnvironmentObject var vm: TransactionViewModel
    @State private var selectedPeriod: Period = .month
    
    enum Period: String, CaseIterable {
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Period Selector
                    Picker("Period", selection: $selectedPeriod) {
                        ForEach(Period.allCases, id: \.self) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Monthly Summary Card
                    VStack(spacing: 16) {
                        Text("This Month")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack(spacing: 20) {
                            SummaryBox(
                                title: "Income",
                                amount: vm.monthlyIncome(),
                                color: .green
                            )
                            
                            SummaryBox(
                                title: "Expenses",
                                amount: vm.monthlyExpense(),
                                color: .red
                            )
                        }
                        
                        VStack(spacing: 8) {
                            HStack {
                                Text("Balance")
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(" ₹ \(vm.monthlyBalance(), specifier: "%.2f")")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(vm.monthlyBalance() >= 0 ? .green : .red)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8)
                    .padding(.horizontal)
                    
                    // Spending by Category Chart
                    if !vm.expensesByCategory().isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Spending by Category")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            // Pie Chart
                            CategoryPieChart(data: vm.expensesByCategory())
                                .frame(height: 250)
                                .padding()
                            
                            // Category List
                            VStack(spacing: 12) {
                                ForEach(Array(vm.expensesByCategory().sorted(by: { $0.value > $1.value })), id: \.key) { category, amount in
                                    CategoryRow(
                                        category: category,
                                        amount: amount,
                                        percentage: calculatePercentage(amount: amount)
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                        .background(Color.white)
                        .cornerRadius(16)
                        .shadow(color: .black.opacity(0.05), radius: 8)
                        .padding(.horizontal)
                    }
                    
                    // Income vs Expense Chart (Last 7 days)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Last 7 Days")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        IncomeExpenseChart(transactions: vm.transactions)
                            .frame(height: 200)
                            .padding()
                    }
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.05), radius: 8)
                    .padding(.horizontal)
                    
                    // Export Buttons
                    VStack(spacing: 12) {
                        Button {
                            exportToPDF()
                        } label: {
                            Label("Export to PDF", systemImage: "doc.text")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.primary)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        
                        Button {
                            exportToCSV()
                        } label: {
                            Label("Export to CSV", systemImage: "tablecells")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColors.primary.opacity(0.1))
                                .foregroundColor(AppColors.primary)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
                .padding(.top)
            }
            .navigationTitle("Statistics")
            .background(Color.gray.opacity(0.05))
        }
    }
    
    private func calculatePercentage(amount: Double) -> Double {
        let total = vm.totalExpense
        return total > 0 ? (amount / total) * 100 : 0
    }
    
    private func exportToPDF() {
        print("Exporting to PDF...")
    }
    
    private func exportToCSV() {
        print("Exporting to CSV...")
    }
}

// Summary Box Component
struct SummaryBox: View {
    let title: String
    let amount: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(" ₹ \(amount, specifier: "%.2f")")
                .font(.title3)
                .bold()
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

// Category Row Component
struct CategoryRow: View {
    let category: TransactionCategory
    let amount: Double
    let percentage: Double
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(category.color.opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: category.icon)
                    .foregroundColor(category.color)
            }
            
            // Category Name
            Text(category.rawValue)
                .font(.subheadline)
            
            Spacer()
            
            // Amount and Percentage
            VStack(alignment: .trailing, spacing: 2) {
                Text(" ₹ \(amount, specifier: "%.2f")")
                    .font(.subheadline)
                    .bold()
                
                Text("\(percentage, specifier: "%.1f")%")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
    }
}

// Category Pie Chart
struct CategoryPieChart: View {
    let data: [TransactionCategory: Double]
    
    var body: some View {
        if #available(iOS 17.0, *) {
            Chart(Array(data.sorted(by: { $0.value > $1.value })), id: \.key) { category, amount in
                SectorMark(
                    angle: .value("Amount", amount),
                    innerRadius: .ratio(0.5),
                    angularInset: 2
                )
                .foregroundStyle(category.color)
                .annotation(position: .overlay) {
                    if amount > data.values.reduce(0, +) * 0.1 {
                        Text(" ₹\(Int(amount))")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.white)
                    }
                }
            }
        } else {
            VStack {
                ForEach(Array(data.sorted(by: { $0.value > $1.value })), id: \.key) { category, amount in
                    HStack {
                        Circle()
                            .fill(category.color)
                            .frame(width: 12, height: 12)
                        Text(category.rawValue)
                        Spacer()
                        Text(" ₹ \(amount, specifier: "%.2f")")
                            .bold()
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }
}

// Income vs Expense Chart
struct IncomeExpenseChart: View {
    let transactions: [Transaction]
    
    private var chartData: [(date: Date, income: Double, expense: Double)] {
        let calendar = Calendar.current
        let last7Days = (0..<7).map { calendar.date(byAdding: .day, value: -$0, to: Date())! }
        
        return last7Days.reversed().map { date in
            let dayTransactions = transactions.filter {
                calendar.isDate($0.date, inSameDayAs: date)
            }
            
            let income = dayTransactions
                .filter { $0.type == .income }
                .reduce(0) { $0 + $1.amount }
            
            let expense = dayTransactions
                .filter { $0.type == .expense }
                .reduce(0) { $0 + $1.amount }
            
            return (date: date, income: income, expense: expense)
        }
    }
    
    var body: some View {
        if #available(iOS 16.0, *) {
            Chart {
                ForEach(chartData, id: \.date) { item in
                    BarMark(
                        x: .value("Day", item.date, unit: .day),
                        y: .value("Income", item.income)
                    )
                    .foregroundStyle(.green)
                    
                    BarMark(
                        x: .value("Day", item.date, unit: .day),
                        y: .value("Expense", -item.expense)
                    )
                    .foregroundStyle(.red)
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel {
                            Text(date.formatted(.dateTime.weekday(.narrow)))
                        }
                    }
                }
            }
        } else {
            VStack(spacing: 8) {
                ForEach(chartData, id: \.date) { item in
                    HStack {
                        Text(item.date.formatted(.dateTime.weekday(.abbreviated)))
                            .frame(width: 40)
                        
                        HStack(spacing: 4) {
                            Rectangle()
                                .fill(Color.green)
                                .frame(width: max(0, CGFloat(item.income) * 2))
                            
                            Rectangle()
                                .fill(Color.red)
                                .frame(width: max(0, CGFloat(item.expense) * 2))
                        }
                        .frame(height: 20)
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    StatisticsView()
        .environmentObject(TransactionViewModel())
}
