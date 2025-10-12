//
//  RecipeAppApp.swift
//  RecipeApp
//
//  Created by Ömer Köse on 30.09.2025.
//

import SwiftUI

@main
struct RecipeeApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
