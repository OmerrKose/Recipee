//
//  MealDetailView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 8.10.2025.
//

import SwiftUI

struct MealDetailView: View {
    var meal: Meal
    
    var body: some View {
        ScrollView(.vertical) {
            
            // Meal image
            AsyncImage(url: meal.thumbnailURL ) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success(let image):
                    image
                        .resizable()
                        .frame(maxWidth: .infinity)
                case .failure:
                    Image(systemName: "photo")
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 300)
            .clipped()
            .background(Color(.systemBackground))
            .shadow(radius: 4)
            
            LazyVStack(alignment: .leading, spacing: 12) {
                // Meal name
                Text(meal.name)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)

                // Meal origin
                if let area = meal.area {
                    TitleAndExplanationView(
                        title: "Origin:",
                        explanation: area,
                        imageName: "flag"
                    )
                }
                
                // Category
                if let category = meal.category {
                    TitleAndExplanationView(
                        title: "Category:",
                        explanation: category,
                        imageName: "list.bullet.rectangle"
                    )
                }
                
                // Tags
                if let _ = meal.tags {
                    TitleAndExplanationView(
                        title: "Tags:",
                        explanation: meal.tagsList.joined(separator: " • "),
                        imageName: "tag"
                    )
                }
                
                Spacer()
                
                // Ingredients
                if !meal.ingredients.isEmpty {
                    TitleAndExplanationView(
                        title: "Ingredients:",
                        imageName: "fork.knife"
                    )
                    IngredientsListView(ingredients: meal.ingredients)
                }
                
                Spacer()
                
                // Instructions
                if let instructions = meal.instructions {
                    VStack(alignment: .leading, spacing: 8) {
                        TitleAndExplanationView(
                            title: "Instructions:",
                            imageName: "book"
                        )
                        
                        Text(instructions)
                            .font(.default)
                            .multilineTextAlignment(.leading)
                    }
                }
                
                Spacer()
                
                // Youtube link
                if let link = meal.youtubeURL {
                    TitleAndExplanationView(
                        title: "Youtube",
                        imageName: "video",
                        link: link
                    )
                }
                
                if let source = meal.source {
                    TitleAndExplanationView(
                        title: "Source",
                        explanation: source,
                        imageName: "globe",
                        link: source,
                    )
                }
            } //: VStack
            .padding(.horizontal)
            .padding(.bottom)
            
        } //: ScrollView
        .navigationTitle(meal.name)
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.hidden)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    let meal = Meal(
        id: "52768",
        name: "Apple Frangipan Tart",
        category: "Dessert",
        area: "British",
        instructions: "Preheat the oven to 200C/180C Fan/Gas 6.\r\nPut the biscuits in a large re-sealable freezer bag and bash with a rolling pin into fine crumbs. Melt the butter in a small pan, then add the biscuit crumbs and stir until coated with butter. Tip into the tart tin and, using the back of a spoon, press over the base and sides of the tin to give an even layer. Chill in the fridge while you make the filling.\r\nCream together the butter and sugar until light and fluffy. You can do this in a food processor if you have one. Process for 2-3 minutes. Mix in the eggs, then add the ground almonds and almond extract and blend until well combined.\r\nPeel the apples, and cut thin slices of apple. Do this at the last minute to prevent the apple going brown. Arrange the slices over the biscuit base. Spread the frangipane filling evenly on top. Level the surface and sprinkle with the flaked almonds.\r\nBake for 20-25 minutes until golden-brown and set.\r\nRemove from the oven and leave to cool for 15 minutes. Remove the sides of the tin. An easy way to do this is to stand the tin on a can of beans and push down gently on the edges of the tin.\r\nTransfer the tart, with the tin base attached, to a serving plate. Serve warm with cream, crème fraiche or ice cream.",
        thumbnailString: "https://www.themealdb.com/images/media/meals/wxywrq1468235067.jpg",
        tags: "Tart,Baking,Fruity",
        youtubeURL: "https://www.youtube.com/watch?v=rp8Slv4INLk",
        source: "",
        ingredient1: "digestive biscuits",
        ingredient2: "butter",
        ingredient3: "Bramley apples",
        ingredient4: "Salted Butter",
        ingredient5: "caster sugar",
        ingredient6: "free-range eggs, beaten",
        ingredient7: "ground almonds",
        ingredient8: "almond extract",
        ingredient9: "flaked almonds",
        ingredient10: "", ingredient11: "", ingredient12: "", ingredient13: "", ingredient14: "", ingredient15: "", ingredient16: "", ingredient17: "", ingredient18: "", ingredient19: "", ingredient20: "",
        measure1: "175g/6oz",
        measure2: "75g/3oz",
        measure3: "200g/7oz",
        measure4: "75g/3oz",
        measure5: "75g/3oz",
        measure6: "2",
        measure7: "75g/3oz",
        measure8: "1 tsp",
        measure9: "50g/1¾oz",
        measure10: "", measure11: "", measure12: "", measure13: "", measure14: "", measure15: "", measure16: "", measure17: "", measure18: "", measure19: "", measure20: ""
    )
    
    MealDetailView(meal: meal)
}
