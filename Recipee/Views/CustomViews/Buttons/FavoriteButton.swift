//
//  FavoriteButton.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

struct FavoriteButton: View {
    let isFavorite: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .font(.title3)
                .foregroundStyle(isFavorite ? .red : .secondary)
                .scaleEffect(isFavorite ? 1.1 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isFavorite)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
        .accessibilityHint("Tap to toggle favorite status")
    }
}

#Preview {
    VStack(spacing: 20) {
        FavoriteButton(isFavorite: false) {
            print("Toggle favorite")
        }
        
        FavoriteButton(isFavorite: true) {
            print("Toggle favorite")
        }
    }
    .padding()
}
