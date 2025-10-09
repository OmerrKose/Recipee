//
//  AllMealsListView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

struct AllMealsView: View {
    @EnvironmentObject var viewModel: AllMealsViewModel
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .idle:
                Color.clear.task { await viewModel.fetchMeals() }
                
            case .loading:
                ProgressView("Loading...")
                
            case .loaded(let meals):
                NavigationStack {
                    ScrollView(.vertical) {
                        LazyVStack(spacing: 12) {
                            ForEach(meals) { meal in
                                NavigationLink {
                                    MealDetailView(meal: meal)
                                } label: {
                                    MealsRowView(meal: meal)
                                }
                                .buttonStyle(.plain)
                            } //: Loop
                        } //: LazyVstack
                        .padding(.horizontal, 16)
                        .padding(.vertical,8)
                    } //: ScrollView
                    .background(Color(.secondarySystemBackground))
                    .navigationTitle("Meals")
                } //: NavigationStack
                
            case .error(let message):
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.red)
                    
                    Text("An error occured")
                        .font(.headline)
                    
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(Color.secondary)
                    
                    Button("Retry") {
                        Task {
                            await viewModel.fetchMeals()
                        }
                    }
                } //: VStack
                .navigationTitle("Categories")
                .toolbarTitleDisplayMode(.large)
                .background(Color(.secondarySystemBackground))
                .task {
                    if case .idle = viewModel.state {
                        await viewModel.fetchMeals()
                    }
                }
            } //: Switch
        } //: ZStack
    }
}

#Preview {
    AllMealsView()
        .environmentObject(AllMealsViewModel())
}
