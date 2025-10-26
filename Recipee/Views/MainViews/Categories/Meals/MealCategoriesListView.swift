//
//  MealCategoriesListView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 12.10.2025.
//

import SwiftUI

struct MealCategoriesListView: View {
    @EnvironmentObject var viewModel: MealViewModel
    
    var mealCategory: String
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .idle:
                Color.clear.task { await viewModel.fetchMeals(with: mealCategory) }
                
            case .loading:
                LoadingView("Loading meals...")
                
            case .loaded(let meals):
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(meals) { meal in
                            NavigationLink {
                                MealDetailViewById(mealId: meal.id)
                            } label: {
                                MealsListRowView(meal: meal)
                                    .padding(.horizontal, 8)
                            }
                            .buttonStyle(.plain)
                            
                        } //: Loop
                    } //: LazyVStack
                } //: ScrollView
                .scrollIndicators(.hidden)
                
            case .error(let message):
                ServiceErrorView(message: message) {
                    await viewModel.fetchMeals(with: mealCategory)
                }
            } //: Switch
        } //: ZStack
        .navigationTitle(mealCategory)
        .navigationBarTitleDisplayMode(.inline)
        
        // TODO: Add sorting
    }
}

#Preview {
    MealCategoriesListView(mealCategory: "Dessert")
        .environmentObject(MealViewModel())
}
