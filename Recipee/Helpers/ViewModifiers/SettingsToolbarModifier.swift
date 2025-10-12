//
//  SettingsToolbarModifier.swift
//  RecipeApp
//
//  Created by Ömer Köse on 12.10.2025.
//

import SwiftUI

struct SettingsToolbarModifier: ViewModifier {
    @State private var showingSettings = false
    
    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
            .sheet(isPresented: $showingSettings) {
                NavigationStack {
                    SettingsView()
                }
                .presentationDetents([.medium, .large])
            }
    }
}
