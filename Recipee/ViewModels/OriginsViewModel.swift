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
    
    // MARK: Variables
    @Published var origins: [Origin] = []
    @Published var errorMessage: String?
    @Published var state: LoadingState = .idle
    @Published var sortOrder: SortOrder = .nameAscending
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
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
    
    // MARK: Service Calls
    func fetchOrigins() async {
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
            state = .error(error.localizedDescription)
        }
    }
}
