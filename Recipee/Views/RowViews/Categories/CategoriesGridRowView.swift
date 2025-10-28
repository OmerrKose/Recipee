//
//  CategoriesCustomListView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

/// List element to display a category.
struct CategoriesGridRowView: View {
    var category: Category
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: category.thumbnailURL) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color(.secondarySystemBackground)
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
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                LinearGradient(
                    colors: [.clear, .black.opacity(0.7)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Text(category.name)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12)
                    .shadow(radius: 2)
                
                // Favorite button in top-right corner
                VStack {
                    HStack {
                        Spacer()
                        FavoriteButton(
                            isFavorite: favoritesViewModel.isCategoryFavorite(category)
                        ) {
                            favoritesViewModel.toggleCategoryFavorite(category)
                        }
                        .padding(.top, 8)
                        .padding(.trailing, 8)
                    }
                    Spacer()
                }
            } //: ZStack
        } //: VStack
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(.separator).opacity(0.5), lineWidth: 0.5)
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
    CategoriesGridRowView(category: category)
        .environmentObject(FavoritesViewModel())
}
