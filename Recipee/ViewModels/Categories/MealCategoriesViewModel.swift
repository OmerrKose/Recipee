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
        state = .loading
        errorMessage = nil
        
        // Add a small delay to ensure network is ready
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second
        
        do {
            let response: CategoriesResponse = try await self.networkService.fetch(CategoriesResponse.self, from: .categories)
            
            guard let categories = response.categories else {
                state = .error("No categories found.")
                return
            }
            
            state = .loaded(categories)
        } catch {
            // More specific error handling
            if let networkError = error as? NetworkError {
                state = .error(networkError.errorDescription ?? "Network error occurred")
            } else {
                state = .error("Failed to fetch categories: \(error.localizedDescription)")
            }
        }
    }
}
