//
//  TransactionRowView.swift
//  ExpenseTrackerApp
//
//  Created by Noman belim on 05/02/26.
//

import SwiftUI

struct TransactionRowView: View {
    
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 12) {
            // Category Icon
            ZStack {
                Circle()
                    .fill(transaction.category.color.opacity(0.2))
                    .frame(width: 50, height: 50)
                
                Image(systemName: transaction.category.icon)
                    .foregroundColor(transaction.category.color)
                    .font(.title3)
            }
            
            // Transaction Details
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title)
                    .font(.headline)
                
                HStack(spacing: 4) {
                    Text(transaction.category.rawValue)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("•")
                        .foregroundColor(.gray)
                        .font(.caption)
                    
                    Text(transaction.date.formatted(date: .abbreviated, time: .omitted))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Amount
            Text(formattedAmount)
                .font(.headline)
                .foregroundColor(transaction.type == .income ? .green : .red)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
    
    private var formattedAmount: String {
        let sign = transaction.type == .income ? "+" : "-"
        return String(format: "%@  ₹%.2f", sign, transaction.amount)
    }
}

// Transaction List View (See All)
struct TransactionListView: View {
    
    @EnvironmentObject var vm: TransactionViewModel
    @State private var selectedFilter: TransactionType? = nil
    @State private var showingDeleteAlert = false
    @State private var transactionToDelete: Transaction?
    
    var filteredTransactions: [Transaction] {
        if let filter = selectedFilter {
            return vm.transactions.filter { $0.type == filter }
        }
        return vm.transactions
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Filter Pills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    FilterPill(title: "All", isSelected: selectedFilter == nil) {
                        selectedFilter = nil
                    }
                    
                    FilterPill(title: "Income", isSelected: selectedFilter == .income) {
                        selectedFilter = .income
                    }
                    
                    FilterPill(title: "Expense", isSelected: selectedFilter == .expense) {
                        selectedFilter = .expense
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
            
            // Transactions List
            if filteredTransactions.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "tray")
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("No transactions found")
                        .foregroundColor(.gray)
                        .font(.headline)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredTransactions) { transaction in
                            NavigationLink {
                                TransactionDetailView(transaction: transaction)
                            } label: {
                                TransactionRowView(transaction: transaction)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .contextMenu {
                                Button(role: .destructive) {
                                    transactionToDelete = transaction
                                    showingDeleteAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Transactions")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete Transaction", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let transaction = transactionToDelete {
                    withAnimation {
                        vm.deleteTransaction(transaction)
                    }
                }
            }
        } message: {
            Text("Are you sure you want to delete this transaction?")
        }
    }
}

// Filter Pill Component
struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isSelected ? AppColors.primary : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .gray)
                .cornerRadius(20)
        }
    }
}

// Transaction Detail View
struct TransactionDetailView: View {
    
    let transaction: Transaction
    @EnvironmentObject var vm: TransactionViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                // Amount Card
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(transaction.category.color.opacity(0.2))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: transaction.category.icon)
                            .foregroundColor(transaction.category.color)
                            .font(.system(size: 40))
                    }
                    
                    Text(transaction.type == .income ? "Income" : "Expense")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text(" ₹ \(transaction.amount, specifier: "%.2f")")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(transaction.type == .income ? .green : .red)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .background(Color.gray.opacity(0.05))
                .cornerRadius(20)
                
                // Details
                VStack(spacing: 16) {
                    DetailRow(icon: "text.alignleft", title: "Title", value: transaction.title)
                    DetailRow(icon: "tag.fill", title: "Category", value: transaction.category.rawValue)
                    DetailRow(icon: "calendar", title: "Date", value: transaction.date.formatted(date: .long, time: .omitted))
                    
                    if !transaction.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "note.text")
                                    .foregroundColor(.gray)
                                Text("Notes")
                                    .foregroundColor(.gray)
                            }
                            Text(transaction.notes)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                
                // Delete Button
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    Label("Delete Transaction", systemImage: "trash")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .foregroundColor(.red)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top, 16)
            }
            .padding(.vertical)
        }
        .navigationTitle("Transaction Details")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Delete Transaction", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                vm.deleteTransaction(transaction)
                dismiss()
            }
        } message: {
            Text("Are you sure you want to delete this transaction?")
        }
    }
}

// Detail Row Component
struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 24)
            
            Text(title)
                .foregroundColor(.gray)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

// Placeholder views from original code
struct TransactionDetailsView: View {
    var body: some View {
        Text("Wallet")
            .font(.title)
    }
}
 

struct SectionHeaderView: View {
    let title: String
    let action: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(action)
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    NavigationView {
        TransactionListView()
            .environmentObject(TransactionViewModel())
    }
}
