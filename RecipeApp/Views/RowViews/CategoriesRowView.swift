//
//  CategoriesCustomListView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

struct CategoriesRowView: View {
    var category: Category
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: category.thumbnailURL) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color(.systemGray6)
                            ProgressView()
                        }
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        ZStack {
                            Color(.systemGray5)
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundStyle(.gray)
                        }
                    @unknown default:
                        EmptyView()
                    }
                } //: AsyncImage
                .frame(maxWidth: .infinity)
                .frame(height: 180)
                .clipped()
                
                LinearGradient(
                    colors: [.clear, .black.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)
                
                Text(category.name)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
                    .shadow(radius: 2)
            } //: ZStack
        } //: VStack
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5).opacity(0.5), lineWidth: 0.5)
        )
    }
}

#Preview {
    let category = Category(
        id: "6",
        name: "Pasta",
        thumbnailString: "https://www.themealdb.com/images/category/pasta.png",
        description: "Pasta is a staple food of traditional Italian cuisine, with the most common variety being spaghetti. It is a long, thin pasta made from wheat flour, water, and salt, and is often served with a variety of sauces, meats, and vegetables."
    )
    CategoriesRowView(category: category)
}
