//
//  MealDetailViewById.swift
//  RecipeApp
//
//  Created by Ömer Köse on 12.10.2025.
//

import SwiftUI

/// This view is used to fetch details by id and show user the detail page.
struct MealDetailViewById: View {
    let mealId: String
    
    @StateObject private var viewModel = DetailedMealViewModel()
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .idle, .loading:
                LoadingView("Loading meal details...")
                
            case .loaded(let meals):
                if let meal = meals.first {
                    MealDetailView(meal: meal)
                        .environmentObject(FavoritesViewModel())
                } else {
                    ContentUnavailableView(
                        "Meal Not Found",
                        systemImage: "questionmark.circle"
                    )
                }
                
            case .error(let message):
                ServiceErrorView(message: message) {
                    await viewModel.fetchMeals(for: mealId)
                }
                
            }
        }
        .task {
            await viewModel.fetchMeals(for: mealId)
        }
    }
}

#Preview {
    NavigationStack {
        MealDetailViewById(mealId: "52772")
            .environmentObject(DetailedMealViewModel())
    }
}
