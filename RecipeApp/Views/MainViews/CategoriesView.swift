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

struct CategoriesView: View {
    @State private var selectedTab: CategoryTab = .categories
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Tab bar
                HStack(spacing: 0) {
                    ForEach(CategoryTab.allCases, id: \.self) { tab in
                        TabItem(
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
                .background(Color(.secondarySystemBackground))
                
                // Content
                ZStack {
                    switch selectedTab {
                    case .categories:
                        MealCategoriesView()
                    case .origins:
                        EmptyView()
                    case .ingredients:
                        EmptyView()
                    }
                } //: ZStack
                .frame(maxHeight: .infinity)
                .background(Color(.secondarySystemBackground))
                
            } //: VStack
            .navigationTitle(selectedTab.rawValue)
        } //: NavigationStack
    }
}

#Preview {
    CategoriesView()
        .environmentObject(MealCategoriesViewModel())
}
