//
//  SearchResultsView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

struct SearchResultsView: View {
    let searchResults: SearchResults
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 24) {
                // Meals
                if !searchResults.meals.isEmpty {
                    SearchSectionView(
                        title: "Meals",
                        icon: "fork.knife",
                        color: .orange,
                        itemCount: searchResults.meals.count,
                        initiallyExpanded: searchResults.firstSection == "meals"
                    ) {
                        LazyVStack(spacing: 12) {
                            ForEach(searchResults.meals) { meal in
                                NavigationLink {
                                    MealDetailView(meal: meal)
                                } label: {
                                    MealsDetailedListRowView(meal: meal)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                
                // Favorite Meals
                if !searchResults.favoriteMeals.isEmpty {
                    SearchSectionView(
                        title: "Favorite Meals",
                        icon: "heart.fill",
                        color: .red,
                        itemCount: searchResults.favoriteMeals.count,
                        initiallyExpanded: searchResults.firstSection == "favoriteMeals"
                    ) {
                        LazyVStack(spacing: 12) {
                            ForEach(searchResults.favoriteMeals) { meal in
                                NavigationLink {
                                    MealDetailView(meal: meal)
                                } label: {
                                    MealsDetailedListRowView(meal: meal)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                
                // Favorite Categories
                if !searchResults.favoriteCategories.isEmpty {
                    SearchSectionView(
                        title: "Favorite Categories",
                        icon: "heart.fill",
                        color: .red,
                        itemCount: searchResults.favoriteCategories.count,
                        initiallyExpanded: searchResults.firstSection == "favoriteCategories"
                    ) {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 20) {
                            ForEach(searchResults.favoriteCategories) { category in
                                NavigationLink {
                                    MealCategoriesListView(mealCategory: category.name)
                                        .environmentObject(MealViewModel())
                                } label: {
                                    CategoriesGridRowView(category: category)
                                }
                            }
                        }
                    }
                }
                
                // Categories
                if !searchResults.categories.isEmpty {
                    SearchSectionView(
                        title: "Categories",
                        icon: "square.grid.2x2",
                        color: .blue,
                        itemCount: searchResults.categories.count,
                        initiallyExpanded: searchResults.firstSection == "categories"
                    ) {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 20) {
                            ForEach(searchResults.categories) { category in
                                NavigationLink {
                                    MealCategoriesListView(mealCategory: category.name)
                                        .environmentObject(MealViewModel())
                                } label: {
                                    CategoriesGridRowView(category: category)
                                }
                            }
                        }
                    }
                }
                
                // Origins
                if !searchResults.origins.isEmpty {
                    SearchSectionView(
                        title: "Origins",
                        icon: "flag",
                        color: .green,
                        itemCount: searchResults.origins.count,
                        initiallyExpanded: searchResults.firstSection == "origins"
                    ) {
                        LazyVStack(spacing: 12) {
                            ForEach(searchResults.origins) { origin in
                                NavigationLink {
                                    OriginMealsListView(originName: origin.name)
                                        .environmentObject(MealViewModel())
                                } label: {
                                    OriginsListRowView(origin: origin)
                                        .padding(.horizontal, 8)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                
                // Ingredients
                if !searchResults.ingredients.isEmpty {
                    SearchSectionView(
                        title: "Ingredients",
                        icon: "leaf.fill",
                        color: .green,
                        itemCount: searchResults.ingredients.count,
                        initiallyExpanded: searchResults.firstSection == "ingredients"
                    ) {
                        LazyVStack(spacing: 12) {
                            ForEach(searchResults.ingredients) { ingredient in
                                NavigationLink {
                                    IngredientDetailView(ingredient: ingredient)
                                } label: {
                                    IngredientRowView(ingredient: ingredient)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
}

#Preview {
    SearchResultsView(searchResults: SearchResults())
        .environmentObject(FavoritesViewModel())
}
