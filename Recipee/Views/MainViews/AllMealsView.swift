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
    @State private var selectedLetter: String = "a"
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Letter Selector
                LetterSelectorView(selectedLetter: $selectedLetter)
                    .background(Color(.systemBackground))
                
                // Content
                ZStack {
                    switch viewModel.state {
                    case .idle:
                        Color.clear.task { await viewModel.fetchMeals(startingWith: selectedLetter) }
                        
                    case .loading:
                        LoadingView("Loading meals...")
                        
                    case .loaded(let meals):
                        if meals.isEmpty {
                            ContentUnavailableView {
                                Label("No Meals Found", systemImage: "fork.knife")
                            } description: {
                                Text("There are no meals starting with '\(selectedLetter.uppercased())'.")
                            }
                        } else {
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
                                .padding(.vertical, 8)
                                
                            } //: ScrollView
                        }
                        
                    case .error(let message):
                        ServiceErrorView(message: message) {
                            await viewModel.fetchMeals(startingWith: selectedLetter)
                        }
                    } //: Switch
                } //: ZStack
            } //: VStack
            .background(Color(.systemBackground))
            .navigationTitle("Meals")
            .onChange(of: selectedLetter) { _, newLetter in
                Task {
                    await viewModel.fetchMeals(startingWith: newLetter)
                }
            }
        } //: NavigationStack
    }
}

#Preview {
    AllMealsView()
        .environmentObject(DetailedMealViewModel())
        .environmentObject(FavoritesViewModel())
}
