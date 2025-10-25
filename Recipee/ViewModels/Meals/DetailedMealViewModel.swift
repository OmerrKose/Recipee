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
    
    // MARK: Variables
    @Published var meals: [DetailedMeal] = []
    @Published var state: LoadingState = .idle
    @Published var errorMessage: String?
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Service Calls
    /// Retrieves meals that starts with the given parameters.
    ///   - Parameters:
    ///     - letter: The letter that meals start with.
    func fetchMeals(startingWith letter: String = "a") async {
        state = .loading
        errorMessage = nil
        
        do {
            let response: DetailedMealsResponse = try await self.networkService.fetch(
                DetailedMealsResponse.self,
                from: .allMeals(letter: letter)
            )
            
            guard let meals = response.meals else {
                state = .error("No meals found.")
                return
            }
            
            state = .loaded(meals)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    /// Retrieves meal by given id.
    ///  - Parameters:
    ///     - id: The id of the meal to be retrieved.
    func fetchMeals(for id: String) async {
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
            state = .error(error.localizedDescription)
        }
    }
}
