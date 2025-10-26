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
                // Tab bar
                HStack(spacing: 8) {
                    ForEach(FavoriteTab.allCases, id: \.self) { tab in
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedTab = tab
                            }
                        }) {
                            VStack(spacing: 6) {
                                Text(tab.rawValue)
                                    .font(.system(.subheadline, design: .rounded))
                                    .fontWeight(selectedTab == tab ? .semibold : .medium)
                                    .foregroundStyle(selectedTab == tab ? .primary : Color.secondary.opacity(0.8))
                                    .frame(maxWidth: .infinity)
                            }
                            .padding(.vertical, 12)
                            .padding(.horizontal, 4)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(selectedTab == tab ? Color.accentColor.opacity(0.1) : Color.clear)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selectedTab == tab ? Color.accentColor.opacity(0.3) : Color.clear, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.tertiarySystemBackground))
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 2)
                )
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 16)
                
                // Content
                ScrollView {
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
            }
            .background(Color(.secondarySystemBackground))
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesViewModel())
}
