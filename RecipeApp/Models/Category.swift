//
//  Category.swift
//  RecipeApp
//
//  Created by Ömer Köse on 30.09.2025.
//

import Foundation

struct Category: Codable, Identifiable, Sendable {
    let id: String
    let name: String
    let thumbnailString: String?
    let description: String
    
    var thumbnailURL: URL? {
        guard let thumbnailString = thumbnailString else { return nil }
        return URL(string: thumbnailString)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "idCategory"
        case name = "strCategory"
        case thumbnailString = "strCategoryThumb"
        case description = "strCategoryDescription"
    }
}

struct CategoriesResponse: Codable, Sendable {
    let categories: [Category]
}
