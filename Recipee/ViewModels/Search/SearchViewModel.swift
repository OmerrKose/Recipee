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
    
    // MARK: - Private Properties
    private let networkService: NetworkServiceProtocol
    private var searchTask: Task<Void, Never>?
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Dependencies
    @Published var favoritesViewModel: FavoritesViewModel?
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        
        // Debounce search text changes
        $searchText
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] searchText in
                self?.performSearch(searchText)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Search Methods
    private func performSearch(_ query: String) {
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            searchResults = SearchResults()
            hasSearched = false
            return
        }
        
        hasSearched = true
        isLoading = true
        
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
        searchText = ""
        searchResults = SearchResults()
        hasSearched = false
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
