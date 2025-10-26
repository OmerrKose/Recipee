//
//  AllMealsListView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

/// Lists all available meal depending on first letter.
struct AllMealsView: View {
    @EnvironmentObject var viewModel: DetailedMealViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .idle:
                    Color.clear.task { await viewModel.fetchMeals() }
                    
                case .loading:
                    LoadingView("Loading meals...")
                    
                case .loaded(let meals):
                    ScrollView(.vertical) {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(meals) { meal in
                                NavigationLink {
                                    MealDetailView(meal: meal)
                                } label: {
                                    MealsDetailedListRowView(meal: meal)
                                }
                                .buttonStyle(.plain)
                                
                            } //: Loop
                        } //: LazyVstack
                        .padding(.horizontal, 16)
                        .padding(.vertical,8)
                        
                    } //: ScrollView
                    
                case .error(let message):
                    ServiceErrorView(message: message) {
                        await viewModel.fetchMeals()
                    }
                } //: Switch
            } //: ZStack
            .background(Color(.secondarySystemBackground))
            .navigationTitle("Meals")
            .withSettings()
            
        } //: NavigationStack
    }
}

#Preview {
    AllMealsView()
        .environmentObject(DetailedMealViewModel())
}
