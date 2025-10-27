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
        loadSearchHistory()
        
        // Debounce search text changes for live search (without saving to history)
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
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
    func commitSearch() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        shouldSaveToHistory = true
        performSearch(searchText, saveToHistory: true)
    }
    
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
    
    @MainActor
    private func searchAll(_ query: String) async {
        var results = SearchResults()
        
        // Search categories
        if let categories = await searchCategories(query) {
            results.categories = categories
        }
        
        // Search origins
        if let origins = await searchOrigins(query) {
            results.origins = origins
        }
        
        // Search meals
        if let meals = await searchMeals(query) {
            results.meals = meals
        }
        
        // Search favorites
        if let favorites = searchFavorites(query) {
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
                category.name.localizedCaseInsensitiveContains(query) ||
                category.description.localizedCaseInsensitiveContains(query)
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
    
    func clearSearch() {
        // Cancel any ongoing search
        searchTask?.cancel()
        
        // Reset state
        searchText = ""
        searchResults = SearchResults()
        hasSearched = false
        isLoading = false
    }
    
    // MARK: - Search History Methods
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
    
    func selectFromHistory(_ query: String) {
        searchText = query
        shouldSaveToHistory = false  // Don't save when re-selecting from history
    }
    
    func removeFromHistory(_ query: String) {
        searchHistory.removeAll { $0 == query }
        saveSearchHistory()
    }
    
    func clearSearchHistory() {
        searchHistory.removeAll()
        saveSearchHistory()
    }
    
    private func saveSearchHistory() {
        UserDefaults.standard.set(searchHistory, forKey: searchHistoryKey)
    }
    
    private func loadSearchHistory() {
        if let history = UserDefaults.standard.stringArray(forKey: searchHistoryKey) {
            searchHistory = history
        }
    }
}

// MARK: - Search Results Model
struct SearchResults {
    var categories: [Category] = []
    var origins: [Origin] = []
    var meals: [DetailedMeal] = []
    var favoriteMeals: [DetailedMeal] = []
    var favoriteCategories: [Category] = []
    
    var isEmpty: Bool {
        categories.isEmpty && origins.isEmpty && meals.isEmpty && 
        favoriteMeals.isEmpty && favoriteCategories.isEmpty
    }
    
    var totalCount: Int {
        categories.count + origins.count + meals.count + 
        favoriteMeals.count + favoriteCategories.count
    }
}
