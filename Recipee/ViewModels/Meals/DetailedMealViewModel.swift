//
//  AllMealsViewModel.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import Foundation
import Combine

class DetailedMealViewModel: ObservableObject {
    // Loading state for service
    enum LoadingState {
        case idle
        case loading
        case loaded([DetailedMeal])
        case error(String)
    }
    
    // MARK: - Variables
    @Published var meals: [DetailedMeal] = []
    @Published var state: LoadingState = .idle
    @Published var errorMessage: String?
    
    private let networkService: NetworkServiceProtocol
    private var fetchTask: Task<Void, Never>?
    
    // MARK: - Initializer
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Service Calls
    /// Retrieves meals that starts with the given parameters.
    ///   - Parameters:
    ///     - letter: The letter that meals start with.
    func fetchMeals(startingWith letter: String = "a") async {
        // Cancel any existing fetch task
        fetchTask?.cancel()
        
        // Create new task
        fetchTask = Task {
            state = .loading
            errorMessage = nil
            
            do {
                let response: DetailedMealsResponse = try await self.networkService.fetch(
                    DetailedMealsResponse.self,
                    from: .allMeals(letter: letter)
                )
                
                guard let meals = response.meals else {
                    state = .loaded([])
                    return
                }
                
                state = .loaded(meals)
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
                        state = .error("Failed to fetch meals: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        await fetchTask?.value
    }
    
    /// Retrieves meal by given id.
    ///  - Parameters:
    ///     - id: The id of the meal to be retrieved.
    func fetchMeals(for id: String) async {
        // Cancel any existing fetch task
        fetchTask?.cancel()
        
        // Create new task
        fetchTask = Task {
            state = .loading
            errorMessage = nil
            
            do {
                let response: DetailedMealsResponse = try await self.networkService.fetch(
                    DetailedMealsResponse.self,
                    from: .mealById(id: id)
                )
                
                guard let meals = response.meals else {
                    state = .error("No meals found.")
                    return
                }
                
                state = .loaded(meals)
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
                        state = .error("Failed to fetch meal: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        await fetchTask?.value
    }
}
