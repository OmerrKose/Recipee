//
//  ContentView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 30.09.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var categoriesViewModel = MealCategoriesViewModel()
    @StateObject private var allMealsViewModel = AllMealsViewModel()
    
    var body: some View {
        MainTabView()
            .environmentObject(categoriesViewModel)
            .environmentObject(allMealsViewModel)
    }
}

#Preview {
    ContentView()
}
