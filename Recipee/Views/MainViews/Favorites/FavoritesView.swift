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
    @Namespace private var animation
    
    enum FavoriteTab: String, CaseIterable {
        case meals = "Meals"
        case categories = "Categories"
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Enhanced Tab bar with better styling
                    HStack(spacing: 8) {
                        ForEach(FavoriteTab.allCases, id: \.self) { tab in
                            TabBar(
                                title: tab.rawValue,
                                isSelected: selectedTab == tab,
                                namespace: animation
                            ) {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedTab = tab
                                }
                            }
                        } //: Loop
                    } //: HStack
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 16) // Add padding between tab bar and content
                    
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
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
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
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                }
                .navigationTitle("Favorites")
                .navigationBarTitleDisplayMode(.large)
            }
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesViewModel())
}
