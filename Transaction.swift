//
//  Transaction.swift
//  ExpenseTrackerApp
//
//  Created by Noman belim on 05/02/26.
//

import Foundation
import SwiftUI

// MARK: - Transaction Category
enum TransactionCategory: String, CaseIterable, Codable {
    case food = "Food"
    case transport = "Transport"
    case shopping = "Shopping"
    case entertainment = "Entertainment"
    case bills = "Bills"
    case health = "Health"
    case education = "Education"
    case salary = "Salary"
    case investment = "Investment"
    case other = "Other"
    
    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "car.fill"
        case .shopping: return "cart.fill"
        case .entertainment: return "tv.fill"
        case .bills: return "doc.text.fill"
        case .health: return "heart.fill"
        case .education: return "book.fill"
        case .salary: return "dollarsign.circle.fill"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .other: return "ellipsis.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .food: return .orange
        case .transport: return .blue
        case .shopping: return .purple
        case .entertainment: return .pink
        case .bills: return .red
        case .health: return .green
        case .education: return .indigo
        case .salary: return .green
        case .investment: return .cyan
        case .other: return .gray
        }
    }
}

// MARK: - Transaction Type
enum TransactionType: String, Codable {
    case income
    case expense
}

// MARK: - Transaction Model
struct Transaction: Identifiable, Codable {
    let id: UUID
    let title: String
    let amount: Double
    let date: Date
    let type: TransactionType
    let category: TransactionCategory
    let notes: String
    
    init(
        id: UUID = UUID(),
        title: String,
        amount: Double,
        date: Date,
        type: TransactionType,
        category: TransactionCategory = .other,
        notes: String = ""
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.date = date
        self.type = type
        self.category = category
        self.notes = notes
    }
}

// MARK: - Transaction View Model
class TransactionViewModel: ObservableObject {
    
    @Published var transactions: [Transaction] = [] {
        didSet {
            saveTransactions()
        }
    }
    
    private let transactionsKey = "SavedTransactions"
    
    init() {
        loadTransactions()
        // Add sample data if empty
        if transactions.isEmpty {
//            addSampleData()
        }
    }
    
    // MARK: - Computed Values
    var totalIncome: Double {
        transactions
            .filter { $0.type == .income }
            .map { $0.amount }
            .reduce(0, +)
    }
    
    var totalExpense: Double {
        transactions
            .filter { $0.type == .expense }
            .map { $0.amount }
            .reduce(0, +)
    }
    
    var totalBalance: Double {
        totalIncome - totalExpense
    }
    
    // MARK: - Monthly Summary
    func monthlyIncome(for date: Date = Date()) -> Double {
        transactions
            .filter { $0.type == .income && Calendar.current.isDate($0.date, equalTo: date, toGranularity: .month) }
            .map { $0.amount }
            .reduce(0, +)
    }
    
    func monthlyExpense(for date: Date = Date()) -> Double {
        transactions
            .filter { $0.type == .expense && Calendar.current.isDate($0.date, equalTo: date, toGranularity: .month) }
            .map { $0.amount }
            .reduce(0, +)
    }
    
    func monthlyBalance(for date: Date = Date()) -> Double {
        monthlyIncome(for: date) - monthlyExpense(for: date)
    }
    
    // Category breakdown
    func expensesByCategory() -> [TransactionCategory: Double] {
        var categoryTotals: [TransactionCategory: Double] = [:]
        
        transactions
            .filter { $0.type == .expense }
            .forEach { transaction in
                categoryTotals[transaction.category, default: 0] += transaction.amount
            }
        
        return categoryTotals
    }
    
    // MARK: - Actions
    func addTransaction(
        title: String,
        amount: Double,
        date: Date = Date(),
        type: TransactionType,
        category: TransactionCategory = .other,
        notes: String = ""
    ) {
        let transaction = Transaction(
            title: title,
            amount: amount,
            date: date,
            type: type,
            category: category,
            notes: notes
        )
        transactions.insert(transaction, at: 0)
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        transactions.removeAll { $0.id == transaction.id }
    }
    
    func updateTransaction(_ transaction: Transaction) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions[index] = transaction
        }
    }
    
    // MARK: - Persistence
    private func saveTransactions() {
        if let encoded = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(encoded, forKey: transactionsKey)
        }
    }
    
    private func loadTransactions() {
        if let data = UserDefaults.standard.data(forKey: transactionsKey),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            transactions = decoded
        }
    }
     
}
