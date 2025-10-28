//
//  IngredientRowView.swift
//  Recipee
//
//  Created by Ömer Köse on 28.10.2025.
//

import SwiftUI

struct IngredientRowView: View {
    let ingredient: Ingredient
    
    var body: some View {
        HStack(spacing: 16) {
            // Ingredient thumbnail
            AsyncImage(url: ingredient.thumbnailUrl) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemBackground))
                        ProgressView()
                    }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.systemGray5))
                        Image(systemName: "fork.knife")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(ingredient.name)
                .font(.headline)
                .foregroundStyle(.primary)
                
                if let description = ingredient.description, !description.isEmpty {
                    Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                }
                
                if let type = ingredient.type, !type.isEmpty {
                    Text(type)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                        .fill(Color.colorForTag(type))
                    )
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
            .font(.caption.weight(.semibold))
            .foregroundStyle(.tertiary)
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 3, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
            .stroke(Color(.separator).opacity(0.5), lineWidth: 0.5)
        )
    }
}

#Preview {
    let ingredient = Ingredient(
        id: "1",
        name: "Chicken Breast",
        description: "Lean protein source",
        thumbnailString: "https://www.themealdb.com/images/ingredients/Chicken.png",
        type: "Meat"
    )
    
    IngredientRowView(ingredient: ingredient)
        .padding()
}

