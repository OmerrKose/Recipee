//
//  TopTabBar.swift
//  RecipeApp
//
//  Created by Ömer Köse on 9.10.2025.
//

import SwiftUI

struct CategoriesTabItem: View {
    let title: String
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.subheadline.weight(isSelected ? .semibold : .medium))
                    .foregroundStyle(isSelected ? .primary : .secondary)
                    .frame(maxWidth: .infinity)
                
                if isSelected {
                    Capsule()
                        .fill(Color.accentColor)
                        .frame(height: 3)
                        .matchedGeometryEffect(id: "tab", in: namespace)
                } else {
                    Capsule()
                        .fill(Color.clear)
                        .frame(height: 3)
                }
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain)
    }
}

#Preview("Tab Item States") {
    @Previewable @Namespace var animation
    
    VStack(spacing: 40) {
        // Selected state
        CategoriesTabItem(
            title: "Categories",
            isSelected: true,
            namespace: animation
        ) {
            print("Categories tapped")
        }
        .frame(width: 120)
        
        // Unselected state
        CategoriesTabItem(
            title: "Origins",
            isSelected: false,
            namespace: animation
        ) {
            print("Origins tapped")
        }
        .frame(width: 120)
        
        // All tabs together
        HStack(spacing: 0) {
            CategoriesTabItem(
                title: "Categories",
                isSelected: true,
                namespace: animation
            ) {}
            
            CategoriesTabItem(
                title: "Origins",
                isSelected: false,
                namespace: animation
            ) {}
            
            CategoriesTabItem(
                title: "Ingredients",
                isSelected: false,
                namespace: animation
            ) {}
        }
        .padding()
        .background(Color(.secondarySystemBackground))
    }
    .padding()
}
