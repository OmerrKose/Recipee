//
//  IngredientDetailView.swift
//  Recipee
//
//  Created by Ömer Köse on 28.10.2025.
//

import SwiftUI

struct IngredientDetailView: View {
    let ingredient: Ingredient
    
    var body: some View {
        ScrollView(.vertical) {
            
            // Ingredient image
            AsyncImage(url: ingredient.thumbnailUrl) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color(.secondarySystemBackground)
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                case .failure:
                    ZStack {
                        Color(.systemGray5)
                        Image(systemName: "fork.knife")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                @unknown default:
                    EmptyView()
                }
            } //: AsyncImage
            .frame(height: 300)
            .background(Color(.systemBackground))
            .shadow(radius: 4)
            
            LazyVStack(alignment: .leading, spacing: 16) {
                // Ingredient name
                Text(ingredient.name)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                
                // Ingredient type
                if let type = ingredient.type, !type.isEmpty {
                    HStack(spacing: 8) {
                        Image(systemName: "tag.fill")
                            .foregroundStyle(Color.colorForTag(type))
                            .font(.title3)
                        
                        Text("Type:")
                            .fontWeight(.semibold)
                        
                        Text(type)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.colorForTag(type))
                            )
                            .foregroundStyle(.white)
                    } //: HStack
                }
                
                Spacer()
                
                // Description
                if let description = ingredient.description, !description.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "book")
                                .foregroundStyle(.secondary)
                                .font(.title3)
                            
                            Text("Description:")
                                .font(.headline)
                                .fontWeight(.semibold)
                        } //: HStack
                        
                        Text(description)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.secondary)
                    } //: VStack
                }
                
                Spacer()
                
            } //: LazyVStack
            .padding(.horizontal)
            .padding(.bottom)
            
        } //: ScrollView
        .background(Color(.systemBackground))
        .navigationTitle(ingredient.name)
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
    } //: Body
}

#Preview {
    let ingredient = Ingredient(
        id: "1",
        name: "Chicken Breast",
        description: "Chicken breast is the lean cut of meat taken from the pectoral muscle on the underside of the chicken. It is white meat that contains a high amount of protein and is low in fat compared to other parts of the chicken.",
        thumbnailString: "https://www.themealdb.com/images/ingredients/Chicken.png",
        type: "Meat"
    )
    
    NavigationStack {
        IngredientDetailView(ingredient: ingredient)
    }
}

