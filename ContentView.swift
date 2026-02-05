//
//  ContentView.swift
//  ExpenseTrackerApp
//
//  Created by Noman belim on 05/02/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack(alignment: .top) {
            
            // Background
            Color.white
                .ignoresSafeArea()
            
            // Green header background
            VStack(spacing: 0) {
                Color(hex: "#5F8F87")
                    .frame(height: 320)
                    .ignoresSafeArea(edges: .top)
                
                Spacer()
            }
            
            VStack(spacing: 24) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Good afternoon,")
                            .foregroundColor(.white.opacity(0.9))
                        Text("Noman Belim")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                    }
                    Spacer()
                    
                    Button {
                        // Notification action
                    } label: {
                        Image(systemName: "bell")
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal)
                
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Total Balance")
                                .foregroundColor(.white.opacity(0.9))
                            
                            Image(systemName: "chevron.up")
                                .foregroundColor(.white.opacity(0.7))
                            
                            Spacer()
                            
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                        }
                        
                        Text(" ₹ 2,548.00")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                    }
                    
                    HStack { 
                        
                        Spacer()
                         
                    }
                }
                .padding()
                .background(Color(hex: "#5F8F87"))
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(
                    color: Color.black.opacity(0.25),
                    radius: 15,
                    x: 0,
                    y: 8
                )
                .padding(.horizontal)
            }
            .padding(.top, 80)
        }
    }
}

#Preview {
    ContentView()
}
 

extension Color {
    init(hex: String) {
        let hex = hex.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hex)
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        self.init(
            red: Double((rgb >> 16) & 0xff) / 255,
            green: Double((rgb >> 8) & 0xff) / 255,
            blue: Double(rgb & 0xff) / 255
        )
    }
}
