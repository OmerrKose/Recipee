//
//  OriginMeal.swift
//  RecipeApp
//
//  Created by Ömer Köse on 11.10.2025.
//

import Foundation

/// Simple meal object that includes, id, name and image url of the meal.
struct Meal: Codable, Identifiable, Sendable {
    let id: String
    let name: String
    let thumbnailString: String?
    
    var thumbnailURL: URL? {
        guard let thumbnailString = thumbnailString else { return nil }
        return URL(string: thumbnailString)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case thumbnailString = "strMealThumb"
    }
}


struct MealsResponse: Codable, Sendable {
    let meals: [Meal]?
    
    enum CodingKeys: String, CodingKey {
        case meals = "meals"
    }
}
