//
//  MealDBEndpoint.swift
//  RecipeApp
//
//  Created by Ömer Köse on 30.09.2025.
//

import Foundation

nonisolated enum MealDBEndpoint: Sendable {
    case categories
    case allMeals(letter: String)
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "www.themealdb.com"
        
        switch self {
        case .categories:
            components.path = "/api/json/v1/1/categories.php"
        case .allMeals(let letter):
            components.path = "/api/json/v1/1/search.php"
            components.queryItems = [URLQueryItem(name: "f", value: letter)]
        }
        
        return components.url
    }
}
