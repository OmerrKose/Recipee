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
    
    // MARK: Variables
    @Published var categories: [Category] = []
    @Published var errorMessage: String?
    @Published var state: LoadingState = .idle
    @Published var sortOrder: SortOrder = .nameAscending
    
    private let networkService: NetworkServiceProtocol
    private var fetchTask: Task<Void, Never>?
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
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
    
    
    // MARK: Service Calls
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
