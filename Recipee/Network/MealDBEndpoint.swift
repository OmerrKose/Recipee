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
    case mealById(id: String)
    case mealByCategory(category: String)
    case mealByOrigin(country: String)
    case origins
    case ingredients
    
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
        case .origins:
            components.path = "/api/json/v1/1/list.php"
            components.queryItems = [URLQueryItem(name: "a", value: "list")]
        case .mealByOrigin(let country):
            components.path = "/api/json/v1/1/filter.php"
            components.queryItems = [URLQueryItem(name: "a", value: country)]
        case .mealById(let id):
            components.path = "/api/json/v1/1/lookup.php"
            components.queryItems = [URLQueryItem(name: "i", value: id)]
        case .mealByCategory(let category):
            components.path = "/api/json/v1/1/filter.php"
            components.queryItems = [URLQueryItem(name: "c", value: category)]
        case .ingredients:
            components.path = "/api/json/v1/1/list.php"
            components.queryItems = [URLQueryItem(name: "i", value: "list")]
        }
        
        return components.url
    }
}
