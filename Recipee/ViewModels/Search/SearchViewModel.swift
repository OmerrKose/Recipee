//
//  SearchViewModel.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var searchText: String = ""
    @Published var searchResults: SearchResults = SearchResults()
    @Published var isLoading: Bool = false
    @Published var hasSearched: Bool = false
    @Published var searchHistory: [String] = []
    @Published var suggestions: [String] = []
    
    // Search filters
    @Published var filterFavorites: Bool = true
    @Published var filterCategories: Bool = true
    @Published var filterOrigins: Bool = true
    @Published var filterMeals: Bool = true
    @Published var filterIngredients: Bool = true
    
    // MARK: - Private Properties
    private let networkService: NetworkServiceProtocol
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    private let searchHistoryKey = "searchHistory"
    private let maxHistoryCount = 20
    private var shouldSaveToHistory: Bool = false
    
    // MARK: - Dependencies
    @Published var favoritesViewModel: FavoritesViewModel?
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        
        // Initialize UserDefaults keys if they don't exist (to match @AppStorage defaults)
        let defaults = UserDefaults.standard
        if defaults.object(forKey: "searchHistoryEnabled") == nil {
            defaults.set(true, forKey: "searchHistoryEnabled")
        }
        if defaults.object(forKey: "autoSuggestionsEnabled") == nil {
            defaults.set(true, forKey: "autoSuggestionsEnabled")
        }
        
        loadSearchHistory()
        
        // Debounce search text changes for live search (without saving to history)
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .dropFirst() // Skip the initial value to prevent unnecessary search on init
            .sink { [weak self] searchText in
                guard let self = self else { return }
                // Only search if text is not empty
                if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    self.performSearch(searchText, saveToHistory: false)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Search Methods
    /// Commits the current search and saves it to history
    func commitSearch() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        shouldSaveToHistory = true
        performSearch(searchText, saveToHistory: true)
    }
    
    /// Performs a search with optional history saving
    /// - Parameters:
    ///   - query: The search query to execute
    ///   - saveToHistory: Whether to save this search to history
    private func performSearch(_ query: String, saveToHistory: Bool = false) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults = SearchResults()
            hasSearched = false
            return
        }
        
        hasSearched = true
        isLoading = true
        shouldSaveToHistory = saveToHistory
        
        // Cancel any existing search
        searchTask?.cancel()
        
        searchTask = Task {
            await searchAll(query)
        }
    }
    
    /// Searches across all enabled filter categories (categories, origins, meals, ingredients, favorites)
    /// - Parameter query: The search query to execute
    @MainActor
    private func searchAll(_ query: String) async {
        var results = SearchResults()
        
        // Search categories (if filter enabled)
        if filterCategories, let categories = await searchCategories(query) {
            results.categories = categories
        }
        
        // Search origins (if filter enabled)
        if filterOrigins, let origins = await searchOrigins(query) {
            results.origins = origins
        }
        
        // Search meals (if filter enabled)
        if filterMeals, let meals = await searchMeals(query) {
            results.meals = meals
        }
        
        // Search ingredients (if filter enabled)
        if filterIngredients, let ingredients = await searchIngredients(query) {
            results.ingredients = ingredients
        }
        
        // Search favorites (if filter enabled)
        if filterFavorites, let favorites = searchFavorites(query) {
            results.favoriteMeals = favorites.meals
            results.favoriteCategories = favorites.categories
        }
        
        searchResults = results
        isLoading = false
        
        // Add to search history only if the user committed the search
        if shouldSaveToHistory {
            addToSearchHistory(query)
            shouldSaveToHistory = false
        }
    }
    
    private func searchCategories(_ query: String) async -> [Category]? {
        do {
            let response: CategoriesResponse = try await networkService.fetch(
                CategoriesResponse.self,
                from: .categories
            )
            
            guard let categories = response.categories else { return nil }
            
            return categories.filter { category in
                category.name.localizedCaseInsensitiveContains(query)
            }
        } catch {
            return nil
        }
    }
    
    private func searchOrigins(_ query: String) async -> [Origin]? {
        do {
            let response: OriginsResponse = try await networkService.fetch(
                OriginsResponse.self,
                from: .origins
            )
            
            guard let origins = response.origins else { return nil }
            
            return origins.filter { origin in
                origin.name.localizedCaseInsensitiveContains(query)
            }
        } catch {
            return nil
        }
    }
    
    private func searchMeals(_ query: String) async -> [DetailedMeal]? {
        do {
            let response: DetailedMealsResponse = try await networkService.fetch(
                DetailedMealsResponse.self,
                from: .allMeals(letter: String(query.prefix(1)).lowercased())
            )
            
            guard let meals = response.meals else { return nil }
            
            return meals.filter { meal in
                meal.name.localizedCaseInsensitiveContains(query) ||
                meal.category?.localizedCaseInsensitiveContains(query) == true ||
                meal.area?.localizedCaseInsensitiveContains(query) == true ||
                meal.tagsList.contains { $0.localizedCaseInsensitiveContains(query) }
            }
        } catch {
            return nil
        }
    }
    
    private func searchFavorites(_ query: String) -> (meals: [DetailedMeal], categories: [Category])? {
        guard let favoritesViewModel = favoritesViewModel else { return nil }
        
        let favoriteMeals = favoritesViewModel.favoriteMeals.filter { meal in
            meal.name.localizedCaseInsensitiveContains(query) ||
            meal.category?.localizedCaseInsensitiveContains(query) == true ||
            meal.area?.localizedCaseInsensitiveContains(query) == true
        }
        
        let favoriteCategories = favoritesViewModel.favoriteCategories.filter { category in
            category.name.localizedCaseInsensitiveContains(query) ||
            category.description.localizedCaseInsensitiveContains(query)
        }
        
        return (favoriteMeals, favoriteCategories)
    }
    
    private func searchIngredients(_ query: String) async -> [Ingredient]? {
        do {
            let response: IngredientsResponse = try await networkService.fetch(
                IngredientsResponse.self,
                from: .ingredients
            )
            
            guard let ingredients = response.ingredients else { return nil }
            
            return ingredients.filter { ingredient in
                ingredient.name.localizedCaseInsensitiveContains(query) ||
                ingredient.description?.localizedCaseInsensitiveContains(query) == true
            }
        } catch {
            return nil
        }
    }
    
    /// Clears the current search and resets all search state
    func clearSearch() {
        // Cancel any ongoing search
        searchTask?.cancel()
        
        // Reset state
        searchText = ""
        searchResults = SearchResults()
        hasSearched = false
        isLoading = false
        suggestions = []
    }
    
    // MARK: - Search History Methods
    /// Adds a query to search history if enabled
    /// - Parameter query: The search query to add to history
    private func addToSearchHistory(_ query: String) {
        // Check if search history is enabled
        guard UserDefaults.standard.bool(forKey: "searchHistoryEnabled") else { return }
        
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedQuery.isEmpty else { return }
        
        // Remove if already exists
        searchHistory.removeAll { $0.caseInsensitiveCompare(trimmedQuery) == .orderedSame }
        
        // Add to beginning
        searchHistory.insert(trimmedQuery, at: 0)
        
        // Keep only max items
        if searchHistory.count > maxHistoryCount {
            searchHistory = Array(searchHistory.prefix(maxHistoryCount))
        }
        
        saveSearchHistory()
    }
    
    /// Selects a query from search history and fills the search text
    /// - Parameter query: The query to select from history
    func selectFromHistory(_ query: String) {
        searchText = query
        shouldSaveToHistory = false  // Don't save when re-selecting from history
    }
    
    /// Removes a specific query from search history
    /// - Parameter query: The query to remove from history
    func removeFromHistory(_ query: String) {
        searchHistory.removeAll { $0 == query }
        saveSearchHistory()
    }
    
    /// Clears all search history
    func clearSearchHistory() {
        searchHistory.removeAll()
        saveSearchHistory()
    }
    
    /// Saves search history to UserDefaults
    private func saveSearchHistory() {
        UserDefaults.standard.set(searchHistory, forKey: searchHistoryKey)
    }
    
    /// Loads search history from UserDefaults
    private func loadSearchHistory() {
        if let history = UserDefaults.standard.stringArray(forKey: searchHistoryKey) {
            searchHistory = history
        }
    }
    
    // MARK: - Auto Suggestions Methods
    /// Generates search suggestions based on the query from history and favorites
    /// - Parameter query: The search query to generate suggestions for
    /// - Note: Only generates suggestions if auto-suggestions are enabled in UserDefaults
    func generateSuggestions(for query: String) {
        guard !query.isEmpty else {
            suggestions = []
            return
        }
        
        // Check if auto-suggestions are enabled
        guard UserDefaults.standard.bool(forKey: "autoSuggestionsEnabled") else {
            suggestions = []
            return
        }
        
        var suggestionSet = Set<String>()
        let lowercaseQuery = query.lowercased()
        
        // Suggest from search history that matches the query
        for historyItem in searchHistory {
            if historyItem.lowercased().contains(lowercaseQuery) && historyItem.lowercased() != lowercaseQuery {
                suggestionSet.insert(historyItem)
            }
        }
        
        // Suggest from favorite meal names
        if let favorites = favoritesViewModel {
            for meal in favorites.favoriteMeals {
                if meal.name.lowercased().contains(lowercaseQuery) {
                    suggestionSet.insert(meal.name)
                }
            }
            
            // Suggest from favorite category names
            for category in favorites.favoriteCategories {
                if category.name.lowercased().contains(lowercaseQuery) {
                    suggestionSet.insert(category.name)
                }
            }
        }
        
        suggestions = Array(suggestionSet.prefix(5)) // Limit to 5 suggestions
    }
}

// MARK: - Search Results Model
struct SearchResults {
    var categories: [Category] = []
    var origins: [Origin] = []
    var meals: [DetailedMeal] = []
    var favoriteMeals: [DetailedMeal] = []
    var favoriteCategories: [Category] = []
    var ingredients: [Ingredient] = []
    
    var isEmpty: Bool {
        categories.isEmpty && origins.isEmpty && meals.isEmpty && 
        favoriteMeals.isEmpty && favoriteCategories.isEmpty && ingredients.isEmpty
    }
    
    var totalCount: Int {
        categories.count + origins.count + meals.count + 
        favoriteMeals.count + favoriteCategories.count + ingredients.count
    }
    
    var firstSection: String {
        if !meals.isEmpty {
            return "meals"
        } else if !favoriteMeals.isEmpty {
            return "favoriteMeals"
        } else if !favoriteCategories.isEmpty {
            return "favoriteCategories"
        } else if !categories.isEmpty {
            return "categories"
        } else if !origins.isEmpty {
            return "origins"
        } else if !ingredients.isEmpty {
            return "ingredients"
        }
        return ""
    }
}
