//
//  Ingredient.swift
//  Recipee
//
//  Created by Ömer Köse on 28.10.2025.
//

import Foundation

struct Ingredient: Codable, Identifiable, Sendable {
    let id: String
    let name: String
    let description: String?
    let thumbnailString: String?
    let type: String?
    
    var thumbnailUrl: URL? {
        guard let thumbnailString = thumbnailString else { return nil }
        return URL(string: thumbnailString)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "idIngredient"
        case name = "strIngredient"
        case description = "strDescription"
        case thumbnailString = "strThumb"
        case type = "strType"
    }
}

// MARK: - IngredientsResponse
struct IngredientsResponse: Codable, Sendable {
    let ingredients: [Ingredient]?
    
    enum CodingKeys: String, CodingKey {
        case ingredients = "meals"
    }
}
