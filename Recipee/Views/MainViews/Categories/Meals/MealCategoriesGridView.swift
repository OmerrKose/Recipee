//
//  CategoriesView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 30.09.2025.
//

import SwiftUI

/// Displays meals depending on categories using `CategoriesGridRowView`.
struct MealCategoriesGridView: View {
    @EnvironmentObject var viewModel: MealCategoriesViewModel
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .idle:
                Color.clear.task { await viewModel.fetchCategories() }
                
            case .loading:
                ProgressView("Loading...")
                
            case .loaded:
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 20) {
                    ForEach(viewModel.sortedCategories) { category in
                        NavigationLink {
                            MealCategoriesListView(mealCategory: category.name)
                                .environmentObject(MealViewModel())
                        } label: {
                            CategoriesGridRowView(category: category)
                        }
                    } //: Loop
                } //: LazyVGrid
                .padding(.horizontal, 16)
                
            case .error(let message):
                ServiceErrorView(message: message) {
                    await viewModel.fetchCategories()
                }
                
            } //: Switch
        } //: ZStack
        .background(Color(.secondarySystemBackground))
        .navigationTitle("Categories")
        .withSettings()
        .toolbar {
            SortMenu(
                sortOrder: $viewModel.sortOrder,
                options: [
                    ("Name A-Z", .nameAscending),
                    ("Name Z-A", .nameDescending)
                ]
            )
        }
        .task {
            if case .idle = viewModel.state {
                await viewModel.fetchCategories()
            }
        }
    }
}

#Preview {
    NavigationStack {
        MealCategoriesGridView()
            .environmentObject(MealCategoriesViewModel())
    }
}
