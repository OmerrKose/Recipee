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
            VStack(spacing: 0) {
                // Tab bar
                HStack(spacing: 0) {
                    ForEach(CategoryTab.allCases, id: \.self) { tab in
                        CategoriesTabItem(
                            title: tab.rawValue,
                            isSelected: selectedTab == tab,
                            namespace: animation
                        ) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                selectedTab = tab
                            }
                        }
                    } //: Loop
                } //: HStack
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                
                // Content
                ZStack {
                    switch selectedTab {
                    case .categories:
                        MealCategoriesGridView()
                    case .origins:
                        OriginsListView()
                    case .ingredients:
                        EmptyView()
                    }
                } //: ZStack
                .frame(maxHeight: .infinity)
                
            } //: VStack
            .background(Color(.secondarySystemBackground))
            .navigationTitle(selectedTab.rawValue)
            
        } //: NavigationStack
    }
}

#Preview {
    CategoriesView()
        .environmentObject(MealCategoriesViewModel())
        .environmentObject(OriginsViewModel())
}
