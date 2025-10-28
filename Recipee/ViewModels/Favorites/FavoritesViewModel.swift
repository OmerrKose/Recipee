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
    @Published var favoriteMeals: [DetailedMeal] = []
    @Published var favoriteCategories: [Category] = []
    
    // MARK: - Private Properties
    private let userDefaults = UserDefaults.standard
    private let mealsKey = "favoriteMeals"
    private let categoriesKey = "favoriteCategories"
    
    // MARK: - Initializer
    init() {
        loadFavorites()
    }
    
    // MARK: - Meal Favorites
    func addMealToFavorites(_ meal: DetailedMeal) {
        if !favoriteMeals.contains(where: { $0.id == meal.id }) {
            favoriteMeals.append(meal)
            saveMealsToUserDefaults()
        }
    }
    
    func removeMealFromFavorites(_ meal: DetailedMeal) {
        favoriteMeals.removeAll { $0.id == meal.id }
        saveMealsToUserDefaults()
    }
    
    func isMealFavorite(_ meal: DetailedMeal) -> Bool {
        return favoriteMeals.contains { $0.id == meal.id }
    }
    
    func toggleMealFavorite(_ meal: DetailedMeal) {
        if isMealFavorite(meal) {
            removeMealFromFavorites(meal)
        } else {
            addMealToFavorites(meal)
        }
    }
    
    // MARK: - Category Favorites
    func addCategoryToFavorites(_ category: Category) {
        if !favoriteCategories.contains(where: { $0.id == category.id }) {
            favoriteCategories.append(category)
            saveCategoriesToUserDefaults()
        }
    }
    
    func removeCategoryFromFavorites(_ category: Category) {
        favoriteCategories.removeAll { $0.id == category.id }
        saveCategoriesToUserDefaults()
    }
    
    func isCategoryFavorite(_ category: Category) -> Bool {
        return favoriteCategories.contains { $0.id == category.id }
    }
    
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
    func clearAllFavorites() {
        favoriteMeals.removeAll()
        favoriteCategories.removeAll()
        userDefaults.removeObject(forKey: mealsKey)
        userDefaults.removeObject(forKey: categoriesKey)
    }
}
