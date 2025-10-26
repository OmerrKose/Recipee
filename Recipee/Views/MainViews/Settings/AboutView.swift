//
//  AboutView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            Form {
            Section {
                VStack(spacing: 16) {
                    Image(systemName: "fork.knife")
                        .font(.system(size: 60))
                        .foregroundStyle(Color.accentColor)
                    
                    Text("RecipeApp")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Version 1.0.0")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
            }
            
            Section(header: Text("About")) {
                Label("Built with SwiftUI", systemImage: "swift")
                Label("iOS 16.0+", systemImage: "iphone")
                Label("Recipe Database by TheMealDB", systemImage: "server.rack")
            }
            .listRowBackground(Color(.systemGray6))
            
            Section(header: Text("Developer")) {
                Label("Ömer Köse", systemImage: "person")
                Label("omerkose@example.com", systemImage: "envelope")
            }
            .listRowBackground(Color(.systemGray6))
        }
        .scrollContentBackground(.hidden)
        } //: ZStack
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
