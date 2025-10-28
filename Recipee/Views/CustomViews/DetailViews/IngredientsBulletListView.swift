//
//  IngredientsListView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 8.10.2025.
//

import SwiftUI

struct IngredientsBulletListView: View {
    let ingredients: [(ingredient: String, measure: String)]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(ingredients.indices, id: \.self) { index in
                let item = ingredients[index]
                HStack(alignment: .top, spacing: 6) {
                    Text("•")
                        .fontWeight(.bold)
                    HStack(spacing: 4) {
                        Text(item.ingredient.localizedCapitalized)
                            .fontWeight(.medium)
                        if !item.measure.isEmpty {
                            Text("(\(item.measure))")
                                .foregroundColor(.secondary)
                        }
                    }
                    .font(.callout)
                    .multilineTextAlignment(.leading)
                } //: HStack
            } //: Loop
        } //: VStack
    }
}

#Preview {
    let ingredients: [(ingredient: String, measure: String)] = [
        ("Flour", "2 cups"),
        ("Sugar", "1 cup"),
        ("Eggs", "3"),
        ("Vanilla Extract", ""),
        ("Milk", "1/2 cup")
    ]
    
    IngredientsBulletListView(ingredients: ingredients)
}
