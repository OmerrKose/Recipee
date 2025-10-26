//
//  TopTabBar.swift
//  RecipeApp
//
//  Created by Ömer Köse on 9.10.2025.
//

import SwiftUI

struct TabBar: View {
    let title: String
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Text(title)
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(isSelected ? .semibold : .medium)
                    .foregroundStyle(isSelected ? .primary : Color.secondary.opacity(0.8))
                    .frame(maxWidth: .infinity)
            } //: VStack
            .padding(.vertical, 12)
            .padding(.horizontal, 4)
            .background(
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.accentColor.opacity(0.2))
                            .matchedGeometryEffect(id: "tab-background", in: namespace)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.clear)
                    }
                }
            )
            .overlay(
                Group {
                    if isSelected {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.accentColor.opacity(0.5), lineWidth: 1)
                            .matchedGeometryEffect(id: "tab-border", in: namespace)
                    } else {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.clear, lineWidth: 1)
                    }
                }
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityHint(isSelected ? "Currently selected" : "Tap to select")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview("Tab Item States") {
    @Previewable @Namespace var animation
    
    VStack(spacing: 30) {
        // Individual states
        HStack(spacing: 20) {
            TabBar(
                title: "Categories",
                isSelected: true,
                namespace: animation
            ) {
                print("Categories tapped")
            }
            .frame(width: 120)
            
            TabBar(
                title: "Origins",
                isSelected: false,
                namespace: animation
            ) {
                print("Origins tapped")
            }
            .frame(width: 120)
        }
        
        // Complete tab bar
        HStack(spacing: 8) {
            TabBar(
                title: "Categories",
                isSelected: true,
                namespace: animation
            ) {}
            
            TabBar(
                title: "Origins",
                isSelected: false,
                namespace: animation
            ) {}
            
            TabBar(
                title: "Ingredients",
                isSelected: false,
                namespace: animation
            ) {}
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        )
    }
    .padding()
    .background(Color(.systemBackground))
}
