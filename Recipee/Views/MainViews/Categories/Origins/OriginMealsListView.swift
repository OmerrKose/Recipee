//
//  OriginMealsListView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 11.10.2025.
//

import SwiftUI

struct OriginMealsListView: View {
    @EnvironmentObject var mealsViewModel: DetailedMealViewModel
    @EnvironmentObject var originsMealsViewModel: MealViewModel
    
    var originName: String
    
    var body: some View {
        ZStack {
            switch originsMealsViewModel.state {
            case .idle:
                Color.clear.task { await originsMealsViewModel.fetchMeals(from: originName) }
                
            case .loading:
                LoadingView("Loading meals...")
                
            case .loaded:
                ScrollView(.vertical) {
                    LazyVStack(alignment: .leading, spacing: 12) {
                        ForEach(originsMealsViewModel.sortedMeals) { meal in
                            NavigationLink {
                                MealDetailViewById(mealId: meal.id)
                            } label: {
                                MealsListRowView(meal: meal)
                                    .padding(.horizontal)
                            }
                            .buttonStyle(.plain)
                            
                        } //: Loop
                    } //: Loop
                } //: ScrollView
                .scrollIndicators(.hidden)
                
            case .error(let message):
                ServiceErrorView(message: message) {
                    await originsMealsViewModel.fetchMeals(from: originName)
                }
                
            } //: Switch
        } //: ZStack
        .background(Color(.secondarySystemBackground))
        .navigationTitle(originName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            SortMenu(
                sortOrder: $originsMealsViewModel.sortOrder,
                options: [
                    ("Name A-Z", .nameAscending),
                    ("Name Z-A", .nameDescending)
                ]
            )
        }
        .task {
            await originsMealsViewModel.fetchMeals(from: originName)
        }
    }
}

#Preview {
    NavigationStack {
        OriginMealsListView(originName: "Turkish")
            .environmentObject(MealViewModel())
    }
}
