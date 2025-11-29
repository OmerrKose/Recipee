//
//  AboutView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

struct AboutView: View {
    // MARK: - App Version & Info
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    var miniOSVersion: String {
        return "26.0"  // Change this to match your actual deployment target
    }
    
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
                        
                        Text("Version \(appVersion) (\(buildNumber))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }
                
                Section(header: Text("About")) {
                    Label("Built with SwiftUI", systemImage: "swift")
                    Label("iOS \(miniOSVersion)+", systemImage: "iphone")
                    Label("Recipe Database by TheMealDB", systemImage: "server.rack")
                }
                .listRowBackground(Color(.systemGray6))
                
                Section(header: Text("Developer")) {
                    Label("Ömer Köse", systemImage: "person")
                    Label("omerr.kose99@gmail.com", systemImage: "envelope")
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
