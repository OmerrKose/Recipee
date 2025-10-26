//
//  MainTabView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

/// The tab view that displays all the views.
struct MainTabView: View {
    @EnvironmentObject var categoriesViewModel: MealCategoriesViewModel
    @EnvironmentObject var allMealsViewMdodel: DetailedMealViewModel
    
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
                FavoritesView()
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
        .environmentObject(DetailedMealViewModel())
        .environmentObject(FavoritesViewModel())
}
