//
//  IngredientsViewModel.swift
//  Recipee
//
//  Created by Ömer Köse on 28.10.2025.
//

import Foundation
import Combine

class IngredientsViewModel: ObservableObject {
    // Loading state for service
    enum LoadingState {
        case idle
        case loading
        case loaded([Ingredient])
        case error(String)
    }
    
    // Sort order for categories
    enum SortOrder {
        case nameAscending
        case nameDescending
    }
    
    // MARK: - Published Properties
    /// The list of all ingredients fetched from the API
    @Published var ingredients: [Ingredient] = []
    /// Error message displayed when fetching fails
    @Published var errorMessage: String?
    /// Current loading state of the view model
    @Published var state: LoadingState = .idle
    /// Current sort order for the ingredients list
    @Published var sortOrder: SortOrder = .nameAscending
    
    // MARK: - Private Properties
    private let networkService: NetworkServiceProtocol
    private var fetchTask: Task<Void, Never>?
    
    // MARK: - Computed Properties
    /// Returns ingredients sorted according to the current sort order
    var sortedIngredients: [Ingredient] {
        guard case .loaded(let ingredients) = state else {
            return []
        }
        
        switch sortOrder {
        case .nameAscending:
            return ingredients.sorted { $0.name < $1.name}
        case .nameDescending:
            return ingredients.sorted { $0.name > $1.name}
        }
    }
    
    /// Groups ingredients by their first letter and sorts them according to the current sort order
    var groupedIngredients: [(String, [Ingredient])] {
        let ingredients = sortedIngredients
        let grouped = Dictionary(grouping: ingredients) { ingredient in
            String(ingredient.name.prefix(1).uppercased())
        }
        // Sort letters based on sort order, and sort ingredients within each letter group
        let mapped = grouped.map { (letter, items) -> (String, [Ingredient]) in
            let sortedItems: [Ingredient]
            switch sortOrder {
            case .nameAscending:
                sortedItems = items.sorted { $0.name < $1.name }
            case .nameDescending:
                sortedItems = items.sorted { $0.name > $1.name }
            }
            return (letter, sortedItems)
        }
        
        // Sort letter groups based on sort order
        switch sortOrder {
        case .nameAscending:
            return mapped.sorted(by: { $0.0 < $1.0 })
        case .nameDescending:
            return mapped.sorted(by: { $0.0 > $1.0 })
        }
    }
    
    /// Returns the list of available letters for alphabet navigation
    var availableLetters: [String] {
        groupedIngredients.map { $0.0 }
    }
    
    // MARK: - Initializer
    /// Initializes the view model with a network service
    /// - Parameter networkService: The network service used to fetch data
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Service Calls
    /// Fetches all ingredients from the API
    /// - Note: This method implements task deduplication to prevent multiple simultaneous requests
    func fetchIngredients() async {
        // Cancel any existing fetch task
        fetchTask?.cancel()
        
        // Create new task
        fetchTask = Task {
            state = .loading
            errorMessage = nil
            
            do {
                let response: IngredientsResponse = try await self.networkService.fetch(IngredientsResponse.self, from: .ingredients)
                
                guard let ingredients = response.ingredients else {
                    state = .error("No ingredients found.")
                    return
                }
                
                state = .loaded(ingredients)
            } catch {
                // Handle cancellation specifically - don't update state if cancelled
                if error is CancellationError {
                    return
                }
                
                // Only update state if task is not cancelled
                if !Task.isCancelled {
                    if let networkError = error as? NetworkError {
                        state = .error(networkError.errorDescription ?? "Network error occurred")
                    } else {
                        state = .error("Failed to fetch ingredients: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        await fetchTask?.value
    }
}
