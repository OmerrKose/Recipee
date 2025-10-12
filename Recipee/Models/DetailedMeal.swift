//
//  Meal.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import Foundation

/// A more detailed object of the meal, consist of most the needed details about meal.
struct DetailedMeal: Codable, Identifiable, Sendable {
    let id: String
    let name: String
    let category: String?
    let area: String?
    let instructions: String?
    let thumbnailString: String?
    let tags: String?
    let youtubeURL: String?
    let source: String?
    
    let ingredient1: String?, ingredient2: String?, ingredient3: String?, ingredient4: String?, ingredient5: String?,
        ingredient6: String?, ingredient7: String?, ingredient8: String?, ingredient9: String?, ingredient10: String?,
        ingredient11: String?, ingredient12: String?, ingredient13: String?, ingredient14: String?, ingredient15: String?,
        ingredient16: String?, ingredient17: String?, ingredient18: String?, ingredient19: String?, ingredient20: String?
    
    let measure1: String?, measure2: String?, measure3: String?, measure4: String?, measure5: String?,
        measure6: String?, measure7: String?, measure8: String?, measure9: String?, measure10: String?,
        measure11: String?, measure12: String?, measure13: String?, measure14: String?, measure15: String?,
        measure16: String?, measure17: String?, measure18: String?, measure19: String?, measure20: String?
    
    // MARK: Computed properties
    var thumbnailURL: URL? {
        guard let thumbnailString = thumbnailString else { return nil }
        return URL(string: thumbnailString)
    }
    
    var ingredients: [(ingredient: String, measure: String)] {
        let allIngredients = [
            (ingredient1, measure1), (ingredient2, measure2), (ingredient3, measure3),
            (ingredient4, measure4), (ingredient5, measure5), (ingredient6, measure6),
            (ingredient7, measure7), (ingredient8, measure8), (ingredient9, measure9),
            (ingredient10, measure10), (ingredient11, measure11), (ingredient12, measure12),
            (ingredient13, measure13), (ingredient14, measure14), (ingredient15, measure15),
            (ingredient16, measure16), (ingredient17, measure17), (ingredient18, measure18),
            (ingredient19, measure19), (ingredient20, measure20)
        ]
        
        return allIngredients.compactMap { ingredient, measure in
            guard let ing = ingredient?.trimmingCharacters(in: .whitespaces),
                  let meas = measure?.trimmingCharacters(in: .whitespaces),
                  !ing.isEmpty else {
                return nil
            }
            return (ing, meas)
        }
    }
    
    var tagsList: [String] {
        guard let tags = tags, !tags.isEmpty else { return [] }
        return tags.split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
    }

    // MARK: Coding Keys
    enum CodingKeys: String, CodingKey {
        case id = "idMeal", name = "strMeal", category = "strCategory", area = "strArea",
             instructions = "strInstructions", thumbnailString = "strMealThumb",
             tags = "strTags", youtubeURL = "strYoutube", source = "strSource"
        
        case ingredient1 = "strIngredient1", ingredient2 = "strIngredient2", ingredient3 = "strIngredient3",
             ingredient4 = "strIngredient4", ingredient5 = "strIngredient5", ingredient6 = "strIngredient6",
             ingredient7 = "strIngredient7", ingredient8 = "strIngredient8", ingredient9 = "strIngredient9",
             ingredient10 = "strIngredient10", ingredient11 = "strIngredient11", ingredient12 = "strIngredient12",
             ingredient13 = "strIngredient13", ingredient14 = "strIngredient14", ingredient15 = "strIngredient15",
             ingredient16 = "strIngredient16", ingredient17 = "strIngredient17", ingredient18 = "strIngredient18",
             ingredient19 = "strIngredient19", ingredient20 = "strIngredient20"
        
        case measure1 = "strMeasure1", measure2 = "strMeasure2", measure3 = "strMeasure3",
             measure4 = "strMeasure4", measure5 = "strMeasure5", measure6 = "strMeasure6",
             measure7 = "strMeasure7", measure8 = "strMeasure8", measure9 = "strMeasure9",
             measure10 = "strMeasure10", measure11 = "strMeasure11", measure12 = "strMeasure12",
             measure13 = "strMeasure13", measure14 = "strMeasure14", measure15 = "strMeasure15",
             measure16 = "strMeasure16", measure17 = "strMeasure17", measure18 = "strMeasure18",
             measure19 = "strMeasure19", measure20 = "strMeasure20"
    }
}

// MARK: - MealResponse
struct DetailedMealsResponse: Codable, Sendable {
    let meals: [DetailedMeal]?
}
