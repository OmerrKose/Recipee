//
//  FavoritesViewModel.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import Foundation
import Combine

class FavoritesViewModel: ObservableObject {
    // MARK: - Published Properties
    /// The list of favorite meals
    @Published var favoriteMeals: [DetailedMeal] = []
    /// The list of favorite categories
    @Published var favoriteCategories: [Category] = []
    
    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    private let mealsKey = Constants.UserDefaults.favoriteMeals
    private let categoriesKey = Constants.UserDefaults.favoriteCategories
    
    // MARK: - Initializer
    init() {
        loadFavorites()
    }
    
    // MARK: - Meal Favorites
    /// Adds a meal to favorites if not already present
    /// - Parameter meal: The meal to add to favorites
    func addMealToFavorites(_ meal: DetailedMeal) {
        if !favoriteMeals.contains(where: { $0.id == meal.id }) {
            favoriteMeals.append(meal)
            saveMealsToUserDefaults()
        }
    }
    
    /// Removes a meal from favorites
    /// - Parameter meal: The meal to remove from favorites
    func removeMealFromFavorites(_ meal: DetailedMeal) {
        favoriteMeals.removeAll { $0.id == meal.id }
        saveMealsToUserDefaults()
    }
    
    /// Checks if a meal is in favorites
    /// - Parameter meal: The meal to check
    /// - Returns: True if the meal is in favorites, false otherwise
    func isMealFavorite(_ meal: DetailedMeal) -> Bool {
        return favoriteMeals.contains { $0.id == meal.id }
    }
    
    /// Toggles a meal's favorite status (adds if not favorite, removes if favorite)
    /// - Parameter meal: The meal to toggle
    func toggleMealFavorite(_ meal: DetailedMeal) {
        if isMealFavorite(meal) {
            removeMealFromFavorites(meal)
        } else {
            addMealToFavorites(meal)
        }
    }
    
    // MARK: - Category Favorites
    /// Adds a category to favorites if not already present
    /// - Parameter category: The category to add to favorites
    func addCategoryToFavorites(_ category: Category) {
        if !favoriteCategories.contains(where: { $0.id == category.id }) {
            favoriteCategories.append(category)
            saveCategoriesToUserDefaults()
        }
    }
    
    /// Removes a category from favorites
    /// - Parameter category: The category to remove from favorites
    func removeCategoryFromFavorites(_ category: Category) {
        favoriteCategories.removeAll { $0.id == category.id }
        saveCategoriesToUserDefaults()
    }
    
    /// Checks if a category is in favorites
    /// - Parameter category: The category to check
    /// - Returns: True if the category is in favorites, false otherwise
    func isCategoryFavorite(_ category: Category) -> Bool {
        return favoriteCategories.contains { $0.id == category.id }
    }
    
    /// Toggles a category's favorite status (adds if not favorite, removes if favorite)
    /// - Parameter category: The category to toggle
    func toggleCategoryFavorite(_ category: Category) {
        if isCategoryFavorite(category) {
            removeCategoryFromFavorites(category)
        } else {
            addCategoryToFavorites(category)
        }
    }
    
    // MARK: - Persistence
    private func loadFavorites() {
        loadMealsFromUserDefaults()
        loadCategoriesFromUserDefaults()
    }
    
    private func loadMealsFromUserDefaults() {
        if let data = userDefaults.data(forKey: mealsKey),
           let meals = try? JSONDecoder().decode([DetailedMeal].self, from: data) {
            favoriteMeals = meals
        }
    }
    
    private func saveMealsToUserDefaults() {
        if let data = try? JSONEncoder().encode(favoriteMeals) {
            userDefaults.set(data, forKey: mealsKey)
        }
    }
    
    private func loadCategoriesFromUserDefaults() {
        if let data = userDefaults.data(forKey: categoriesKey),
           let categories = try? JSONDecoder().decode([Category].self, from: data) {
            favoriteCategories = categories
        }
    }
    
    private func saveCategoriesToUserDefaults() {
        if let data = try? JSONEncoder().encode(favoriteCategories) {
            userDefaults.set(data, forKey: categoriesKey)
        }
    }
    
    // MARK: - Clear All
    /// Clears all favorites (both meals and categories) and removes them from UserDefaults
    func clearAllFavorites() {
        favoriteMeals.removeAll()
        favoriteCategories.removeAll()
        userDefaults.removeObject(forKey: mealsKey)
        userDefaults.removeObject(forKey: categoriesKey)
    }
}
