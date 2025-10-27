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
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    @StateObject private var searchViewModel = SearchViewModel()
    
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
            
            // Settings
            Tab("Settings", systemImage: "gear") {
                SettingsView()
                    .environmentObject(searchViewModel)
            }
            
            // Search
            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                SearchView()
                    .environmentObject(searchViewModel)
                    .searchable(
                        text: $searchViewModel.searchText,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: "Search meals, categories, origins..."
                    )
                    .onSubmit(of: .search) {
                        searchViewModel.commitSearch()
                    }
            }
        } //: TabView
        .tabBarMinimizeBehavior(.onScrollDown)
        .onAppear {
            searchViewModel.favoritesViewModel = favoritesViewModel
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(MealCategoriesViewModel())
        .environmentObject(DetailedMealViewModel())
        .environmentObject(FavoritesViewModel())
}
