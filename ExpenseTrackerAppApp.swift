//
//  ExpenseTrackerAppApp.swift
//  ExpenseTrackerApp
//
//  Created by Noman belim on 05/02/26.
//

import SwiftUI
@main
struct ExpenseTrackerApp: App {

    @StateObject var vm = TransactionViewModel()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(vm)
        }
    }
}
