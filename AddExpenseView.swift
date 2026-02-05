//
//  AddExpenseView.swift
//  ExpenseTrackerApp
//
//  Created by Noman belim on 05/02/26.
//

import SwiftUI

struct AddExpenseView: View {
    
    @EnvironmentObject var vm: TransactionViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var title: String = ""
    @State private var amount: String = ""
    @State private var selectedType: TransactionType = .expense
    @State private var selectedCategory: TransactionCategory = .food
    @State private var date: Date = Date()
    @State private var notes: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // For keyboard dismissal
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case title
        case amount
        case notes
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    
                    // Type Selector
                    Picker("Type", selection: $selectedType) {
                        Text("Income").tag(TransactionType.income)
                        Text("Expense").tag(TransactionType.expense)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    VStack(spacing: 16) {
                        
                        // Title Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Title")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            TextField("Enter title", text: $title)
                                .focused($focusedField, equals: .title)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                        }
                        
                        // Amount Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Amount")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            HStack {
                                Text("₹")
                                    .font(.title2)
                                    .foregroundColor(.gray)
                                
                                TextField("0.00", text: $amount)
                                    .focused($focusedField, equals: .amount)
                                    .keyboardType(.decimalPad)
                                    .font(.title2)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(12)
                        }
                        
                        // Category Selector
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(TransactionCategory.allCases, id: \.self) { category in
                                        CategoryButton(
                                            category: category,
                                            isSelected: selectedCategory == category
                                        ) {
                                            selectedCategory = category
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Date Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            DatePicker("", selection: $date, displayedComponents: .date)
                                .datePickerStyle(.compact)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                        }
                        
                        // Notes Input
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes (Optional)")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            TextEditor(text: $notes)
                                .focused($focusedField, equals: .notes)
                                .frame(height: 100)
                                .padding(8)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Add Button
                    Button(action: addTransaction) {
                        Text("Add Transaction")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.primary)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                }
                .padding(.vertical)
            }
            .navigationTitle("Add Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // ✅ KEYBOARD TOOLBAR WITH DONE BUTTON
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        focusedField = nil // Dismiss keyboard
                    }
                    .foregroundColor(AppColors.primary)
                }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func addTransaction() {
        // Validation
        guard !title.isEmpty else {
            alertMessage = "Please enter a title"
            showAlert = true
            return
        }
        
        guard let amountValue = Double(amount), amountValue > 0 else {
            alertMessage = "Please enter a valid amount"
            showAlert = true
            return
        }
        
        // Add transaction
        vm.addTransaction(
            title: title,
            amount: amountValue,
            date: date,
            type: selectedType,
            category: selectedCategory,
            notes: notes
        )
        
        // Reset form
        title = ""
        amount = ""
        notes = ""
        date = Date()
        selectedCategory = .food
        
        // Show success feedback
        focusedField = nil
        
        // Could add success animation here
    }
}

// Category Button Component
struct CategoryButton: View {
    let category: TransactionCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: category.icon)
                    .font(.title2)
                
                Text(category.rawValue)
                    .font(.caption)
            }
            .frame(width: 80, height: 80)
            .background(isSelected ? AppColors.primary : Color.gray.opacity(0.1))
            .foregroundColor(isSelected ? .white : .gray)
            .cornerRadius(12)
        }
    }
}

#Preview {
    AddExpenseView()
        .environmentObject(TransactionViewModel())
}
