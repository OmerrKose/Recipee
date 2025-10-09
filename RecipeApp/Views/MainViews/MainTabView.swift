//
//  MainTabView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var categoriesViewModel: MealCategoriesViewModel
    @EnvironmentObject var allMealsViewMdodel: AllMealsViewModel
    
    var body: some View {
        TabView {
            // All Meals
            Tab("All Meals", systemImage: "list.dash") {
                AllMealsView()
            }
            
            // Categories
            Tab("Categories", systemImage: "square.grid.2x2") {
                CategoriesView()
            }
            
            // Favorites
            Tab("Favorites", systemImage: "star.fill") {
                EmptyView() // TODO: Add favorites
            }
            
            // Search
            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                NavigationStack {
                    SearchView()
                }
            }
        } //: TabView
        .tabBarMinimizeBehavior(.onScrollDown)
    }
}

#Preview {
    MainTabView()
        .environmentObject(MealCategoriesViewModel())
        .environmentObject(AllMealsViewModel())
}
