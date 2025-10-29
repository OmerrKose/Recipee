//
//  CategoriesView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 9.10.2025.
//

import SwiftUI

enum CategoryTab: String, CaseIterable {
    case categories = "Categories"
    case origins = "Origins"
    case ingredients = "Ingredients"
}

/// Main view for categories, displays in 3, `Categories`, `Origins`, and `Ingredients`
struct CategoriesView: View {
    @State private var selectedTab: CategoryTab = .categories
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Native Segmented Picker
                Picker("Browse", selection: $selectedTab) {
                    ForEach(CategoryTab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                
                // Content
                ScrollView {
                    switch selectedTab {
                    case .categories:
                        MealCategoriesGridView()
                    case .origins:
                        OriginsListView()
                    case .ingredients:
                        AllIngredientsListView()
                    }
                }
            } //: VStack
            .background(Color(.systemBackground))
            .navigationTitle(selectedTab.rawValue)
            .navigationBarTitleDisplayMode(.large)
            
        } //: NavigationStack
    }
}

#Preview {
    CategoriesView()
        .environmentObject(MealCategoriesViewModel())
        .environmentObject(OriginsViewModel())
        .environmentObject(MealViewModel())
        .environmentObject(FavoritesViewModel())
        .environmentObject(IngredientsViewModel())
}
