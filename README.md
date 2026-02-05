# 💰 Expense Tracker App

![Swift](https://img.shields.io/badge/Swift-5.9-orange.svg)
![Platform](https://img.shields.io/badge/Platform-iOS%2016.0+-lightgrey.svg)
![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

A modern, feature-rich Expense Tracker iOS application built with SwiftUI. Track your income and expenses in real-time with a beautiful, finance-style interface that automatically updates balances and presents transactions in an intuitive way.

 
---

## ✨ Features

- ✅ **Add Income & Expenses** - Quick transaction entry with category selection
- 📊 **Real-time Balance Calculation** - Automatic updates as you add transactions
- 🎨 **Categorized Transactions** - Visual icons and colors for different categories
- 📱 **Modern Dashboard** - Clean summary cards showing your financial overview
- 📜 **Transaction History** - Chronological list of all your financial activities
- 🔄 **Tab Navigation** - Easy access to Home, Stats, Add, and Profile sections
- 🏗️ **Clean Architecture** - MVVM pattern with scalable, maintainable code

---
 
## 🏗️ Project Architecture

The app follows **MVVM (Model-View-ViewModel)** architecture using SwiftUI's declarative and data-driven approach.

```
ExpenseTrackerApp/
│
├── App/
│   └── ExpenseTrackerAppApp.swift          # App entry point
│
├── Models/
│   └── Transaction.swift                    # Data models
│
├── ViewModels/
│   └── TransactionViewModel.swift           # Business logic & state management
│
├── Views/
│   ├── DashboardView.swift                  # Main dashboard screen
│   ├── AddExpenseView.swift                 # Transaction input form
│   ├── StatisticsView.swift                 # Charts and analytics
│   ├── ProfileView.swift                    # User profile settings
│   └── MainTabView.swift                    # Tab navigation controller
│
├── Components/
│   ├── BalanceCardView.swift                # Reusable balance card
│   └── TransactionRowView.swift             # Transaction list item
│
└── Utilities/
    └── Color+Hex.swift                      # Color extensions
```

---

## 🔄 Application Flow

### 1️⃣ **App Launch**

```swift
@main
struct ExpenseTrackerAppApp: App {
    @StateObject var vm = TransactionViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(vm)
        }
    }
}
```

- `TransactionViewModel` is created once using `@StateObject`
- Injected throughout the app via `environmentObject`
- Acts as a **single source of truth** for all transaction data

### 2️⃣ **Main Tab Navigation**

```swift
TabView {
    DashboardView()
        .tabItem { Label("Home", systemImage: "house.fill") }
    
    StatisticsView()
        .tabItem { Label("Stats", systemImage: "chart.bar.fill") }
    
    AddExpenseView()
        .tabItem { Label("Add", systemImage: "plus.circle.fill") }
    
    ProfileView()
        .tabItem { Label("Profile", systemImage: "person.fill") }
}
```

Each tab represents a major feature area of the app.

### 3️⃣ **Dashboard (Home Screen)**

The dashboard displays:
- 👋 Personalized greeting header
- 💵 Total balance card
- 📊 Income & Expense summary
- 📋 Transaction history list

```swift
@EnvironmentObject var vm: TransactionViewModel
```

SwiftUI automatically refreshes the UI when `@Published` data changes.

### 4️⃣ **Adding Transactions**

Users can add new income or expenses from `AddExpenseView`:

```swift
vm.addTransaction(
    title: title,
    amount: value,
    type: type,
    category: category
)
```

- New transactions are inserted into the list
- Dashboard updates **instantly**
- No manual reload required ✨

---

## 🧠 Core Logic

### Transaction Model

```swift
struct Transaction: Identifiable {
    let id = UUID()
    let title: String
    let amount: Double
    let date: Date
    let type: TransactionType
    let category: Category
}
```

- Represents a single financial record
- Conforms to `Identifiable` for SwiftUI lists
- Includes type (Income/Expense) and category

### ViewModel (Business Logic)

```swift
class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    
    var totalIncome: Double { 
        transactions.filter { $0.type == .income }
                    .reduce(0) { $0 + $1.amount }
    }
    
    var totalExpense: Double { 
        transactions.filter { $0.type == .expense }
                    .reduce(0) { $0 + $1.amount }
    }
    
    var totalBalance: Double { 
        totalIncome - totalExpense 
    }
    
    func addTransaction(...) { ... }
}
```

**Responsibilities:**
- 📦 Store all transactions
- 🧮 Compute financial totals
- 🔔 Notify views about changes

### Real-Time UI Updates

SwiftUI automatically updates the UI because:
- `transactions` is marked with `@Published`
- Views observe changes via `@EnvironmentObject`

**No delegates, notifications, or reload calls needed!**

### Reusable Components

```swift
TransactionRowView(transaction: item)
```

Benefits:
- ✅ Formatting logic stays inside the view
- ✅ Dashboard code remains clean
- ✅ Easy to extend with new fields

---

## 🎨 UI Design Principles

- **ZStack** - Layered layouts for overlapping elements
- **VStack / HStack** - Structured vertical and horizontal layouts
- **Reusable Components** - Cards and rows for consistency
- **Modern Finance UI** - Shadows, rounded corners, and gradients
- **Dynamic Formatting** - Currency and number formatting using `String(format:)`
 
