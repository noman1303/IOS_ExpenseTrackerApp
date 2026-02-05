Expense Tracker App (SwiftUI)

A modern Expense Tracker iOS application built using SwiftUI. The app allows users to add income and expenses in real time, automatically updates balances, and presents transactions in a clean, finance-style UI.

This project focuses on clean architecture, real-time UI updates, and reusable SwiftUI components, making it suitable for learning, interviews, and portfolio use.

⸻

✨ Features
    •    Add Income and Expense transactions
    •    Real-time balance calculation
    •    Categorized transactions with icons and colors
    •    Dashboard with summary cards
    •    Transaction history list
    •    Tab-based navigation (Home, Stats, Add, Profile)
    •    Clean and scalable SwiftUI architecture

⸻

🧱 Project Architecture

The app follows a MVVM-style architecture using SwiftUI’s data-driven approach.

ExpenseTrackerApp
│
├── App
│   └── ExpenseTrackerAppApp.swift
│
├── Models
│   └── Transaction.swift
│
├── ViewModels
│   └── TransactionViewModel.swift
│
├── Views
│   ├── DashboardView.swift
│   ├── AddExpenseView.swift
│   ├── StatisticsView.swift
│   ├── ProfileView.swift
│   └── MainTabView.swift
│
├── Components
│   ├── BalanceCardView.swift
│   └── TransactionRowView.swift
│
└── Utilities
    └── Color+Hex.swift


⸻

🔄 Application Flow

1️⃣ App Launch

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

    •    TransactionViewModel is created once using @StateObject
    •    Injected into the entire app using environmentObject
    •    Acts as a single source of truth

⸻

2️⃣ Main Tab Navigation

MainTabView controls global navigation using TabView.

TabView {
    DashboardView()
    StatisticsView()
    AddExpenseView()
    ProfileView()
}

Each tab represents a major feature area of the app.

⸻

3️⃣ Dashboard (Home Screen)

The dashboard displays:
    •    Greeting header
    •    Total balance card
    •    Income & Expense summary
    •    Transaction history

Data automatically updates when transactions change.

@EnvironmentObject var vm: TransactionViewModel

SwiftUI automatically refreshes the UI when @Published data changes.

⸻

4️⃣ Adding Transactions

Users add new income or expense from AddExpenseView.

vm.addTransaction(
    title: title,
    amount: value,
    type: type
)

    •    New transactions are inserted into the list
    •    Dashboard updates instantly
    •    No manual reload required

⸻

🧠 Core Logic Explained

Transaction Model

struct Transaction: Identifiable {
    let id = UUID()
    let title: String
    let amount: Double
    let date: Date
    let type: TransactionType
    let category: Category
}

    •    Represents a single financial record
    •    Conforms to Identifiable for SwiftUI lists

⸻

ViewModel (Business Logic)

class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []

    var totalIncome: Double { ... }
    var totalExpense: Double { ... }
    var totalBalance: Double { ... }
}

Responsibilities:
    •    Store transactions
    •    Compute totals
    •    Notify views about changes

⸻

Real-Time UI Updates

SwiftUI automatically updates the UI because:
    •    transactions is marked with @Published
    •    Views observe changes via @EnvironmentObject

No delegates, notifications, or reload calls are needed.

⸻

Transaction Row Component

TransactionRowView receives a full model instead of individual values.

TransactionRowView(transaction: item)

This keeps:
    •    Formatting logic inside the view
    •    Dashboard code clean
    •    Easy scalability for future fields

⸻

🎨 UI Design Principles Used
    •    ZStack for layered layouts
    •    VStack / HStack for structure
    •    Reusable components for cards and rows
    •    Shadows and rounded corners for modern finance UI
    •    Dynamic formatting using String(format:)
 
