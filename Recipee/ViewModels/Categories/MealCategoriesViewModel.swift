//
//  CategoriesViewModel.swift
//  RecipeApp
//
//  Created by Ömer Köse on 30.09.2025.
//

import Foundation
import Combine

class MealCategoriesViewModel: ObservableObject {
    // Loading state for service
    enum LoadingState {
        case idle
        case loading
        case loaded([Category])
        case error(String)
    }
    
    // Sort order for categories
    enum SortOrder {
        case nameAscending
        case nameDescending
    }
    
    // MARK: - Published Properties
    /// The list of all categories fetched from the API
    @Published var categories: [Category] = []
    /// Error message displayed when fetching fails
    @Published var errorMessage: String?
    /// Current loading state of the view model
    @Published var state: LoadingState = .idle
    /// Current sort order for the categories list
    @Published var sortOrder: SortOrder = .nameAscending
    
    // MARK: - Private Properties
    private let networkService: NetworkServiceProtocol
    private var fetchTask: Task<Void, Never>?
    
    // MARK: - Computed Properties
    /// Returns categories sorted according to the current sort order
    var sortedCategories: [Category] {
        guard case .loaded(let categories) = state else {
            return []
        }
        
        switch sortOrder {
        case .nameAscending:
            return categories.sorted { $0.name < $1.name}
        case .nameDescending:
            return categories.sorted { $0.name > $1.name}
        }
    }
    
    // MARK: - Initializer
    /// Initializes the view model with a network service
    /// - Parameter networkService: The network service used to fetch data
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Service Calls
    /// Fetches all meal categories from the API
    /// - Note: This method implements task deduplication to prevent multiple simultaneous requests
    func fetchCategories() async {
        // Cancel any existing fetch task
        fetchTask?.cancel()
        
        // Create new task
        fetchTask = Task {
            state = .loading
            errorMessage = nil
            
            do {
                let response: CategoriesResponse = try await self.networkService.fetch(CategoriesResponse.self, from: .categories)
                
                guard let categories = response.categories else {
                    state = .error("No categories found.")
                    return
                }
                
                state = .loaded(categories)
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
                        state = .error("Failed to fetch categories: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        await fetchTask?.value
    }
}
