//
//  SearchRowView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

struct SearchRowView: View {
    let category: Category
    
    var body: some View {
        HStack(spacing: 12) {
            
            // Image
            AsyncImage(url: category.thumbnailURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Name & Description
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.headline)
                
                Text(category.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        } //: HStack
        .padding(.vertical, 4)
    }
}

#Preview {
    let category = Category(
        id: "6",
        name: "Pasta",
        thumbnailString: "https://www.themealdb.com/images/category/pasta.png",
        description: "Pasta is a staple food of traditional Italian cuisine, with the most common variety being spaghetti. It is a long, thin pasta made from wheat flour, water, and salt, and is often served with a variety of sauces, meats, and vegetables."
    )
    SearchRowView(category: category)
}
