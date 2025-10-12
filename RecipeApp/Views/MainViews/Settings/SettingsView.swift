//
//  SettingsView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 12.10.2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        Form {
            Section(header: Text("Appearance")) {
                Toggle(isOn: $isDarkMode) {
                    Label("Dark Mode", systemImage: isDarkMode ? "moon.fill" : "sun.max.fill")
                }
            }
            
            Section(header: Text("General")) {
                Label("App Version 1.0", systemImage: "info.circle")
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
