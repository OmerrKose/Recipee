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
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    // Enhanced Tab bar with better styling
                    HStack(spacing: 8) {
                        ForEach(CategoryTab.allCases, id: \.self) { tab in
                            CategoriesTab(
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
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.tertiarySystemBackground))
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 2)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 16) // Add padding between tab bar and content
                    
                    // Content
                    switch selectedTab {
                    case .categories:
                        MealCategoriesGridView()
                    case .origins:
                        OriginsListView()
                    case .ingredients:
                        EmptyView()
                    }
                    
                } //: VStack
            } //: ScrollView
            .background(
                Color(.secondarySystemBackground)
            )
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
}
