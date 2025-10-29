//
//  FavoritesView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    @State private var selectedTab: FavoriteTab = .meals
    
    enum FavoriteTab: String, CaseIterable {
        case meals = "Meals"
        case categories = "Categories"
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Native Segmented Picker
                Picker("Favorites", selection: $selectedTab) {
                    ForEach(FavoriteTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                ScrollView {
                    VStack(spacing: 0) {
                        // Content
                        switch selectedTab {
                    case .meals:
                        if favoritesViewModel.favoriteMeals.isEmpty {
                            EmptyFavoritesView(
                                title: "No Favorite Meals",
                                message: "Meals you favorite will appear here",
                                systemImage: "heart"
                            )
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(favoritesViewModel.favoriteMeals) { meal in
                                    NavigationLink {
                                        MealDetailView(meal: meal)
                                    } label: {
                                        MealsDetailedListRowView(meal: meal)
                                    } //: NavigationLink
                                    .buttonStyle(.plain)
                                } //: ForEach
                            } //: LazyVStack
                            .padding(.horizontal, 16)
                        }
                        
                    case .categories:
                        if favoritesViewModel.favoriteCategories.isEmpty {
                            EmptyFavoritesView(
                                title: "No Favorite Categories",
                                message: "Categories you favorite will appear here",
                                systemImage: "heart"
                            )
                        } else {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 16),
                                GridItem(.flexible(), spacing: 16)
                            ], spacing: 20) {
                                ForEach(favoritesViewModel.favoriteCategories) { category in
                                    NavigationLink {
                                        MealCategoriesListView(mealCategory: category.name)
                                            .environmentObject(MealViewModel())
                                    } label: {
                                        CategoriesGridRowView(category: category)
                                    } //: NavigationLink
                                } //: ForEach
                            } //: LazyVGrid
                            .padding(.horizontal, 16)
                        }
                        } //: switch
                    } //: VStack
                } //: ScrollView
            } //: VStack
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
        } //: NavigationStack
    } //: Body
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesViewModel())
}
