//
//  ContentView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 30.09.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var categoriesViewModel = MealCategoriesViewModel()
    @StateObject private var allMealsViewModel = DetailedMealViewModel()
    @StateObject private var originsViewModel = OriginsViewModel()
    @StateObject private var originMealsViewModel = MealViewModel()
    
    var body: some View {
        MainTabView()
            .environmentObject(categoriesViewModel)
            .environmentObject(allMealsViewModel)
            .environmentObject(originsViewModel)
            .environmentObject(originMealsViewModel)
    }
}

#Preview {
    ContentView()
}
