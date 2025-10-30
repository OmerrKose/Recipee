//
//  OriginsViewModel.swift
//  RecipeApp
//
//  Created by Ömer Köse on 11.10.2025.
//

import Foundation
import Combine

class OriginsViewModel: ObservableObject {
    // Loading state for service
    enum LoadingState {
        case idle
        case loading
        case loaded([Origin])
        case error(String)
    }
    
    // Sort order for origin names
    enum SortOrder {
        case nameAscending
        case nameDescending
    }
    
    // MARK: - Published Properties
    /// The list of all origins fetched from the API
    @Published var origins: [Origin] = []
    /// Error message displayed when fetching fails
    @Published var errorMessage: String?
    /// Current loading state of the view model
    @Published var state: LoadingState = .idle
    /// Current sort order for the origins list
    @Published var sortOrder: SortOrder = .nameAscending
    
    // MARK: - Private Properties
    private let networkService: NetworkServiceProtocol
    private var fetchTask: Task<Void, Never>?
    
    // MARK: - Computed Properties
    /// Returns origins sorted according to the current sort order
    var sortedOrigins: [Origin] {
        guard case .loaded(let origins) = state else {
            return []
        }
        
        switch sortOrder {
        case .nameAscending:
            return origins.sorted { $0.name < $1.name}
        case .nameDescending:
            return origins.sorted { $0.name > $1.name}
        }
    }
    
    
    // MARK: - Initializer
    /// Initializes the view model with a network service
    /// - Parameter networkService: The network service used to fetch data
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Service Calls
    /// Fetches all origins from the API
    /// - Note: This method implements task deduplication to prevent multiple simultaneous requests
    func fetchOrigins() async {
        // Cancel any existing fetch task
        fetchTask?.cancel()
        
        // Create new task
        fetchTask = Task {
            state = .loading
            errorMessage = nil
            
            do {
                let response: OriginsResponse = try await self.networkService.fetch(OriginsResponse.self, from: .origins)
                
                guard let origins = response.origins else {
                    state = .error("No origins found.")
                    return
                }
                
                state = .loaded(origins)
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
                        state = .error("Failed to fetch origins: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        await fetchTask?.value
    }
}
