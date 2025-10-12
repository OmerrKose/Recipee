//
//  OriginMealsViewModel.swift
//  RecipeApp
//
//  Created by Ömer Köse on 12.10.2025.
//

import Foundation
import Combine

class MealViewModel: ObservableObject {
    // Loading state for service
    enum LoadingState {
        case idle
        case loading
        case loaded([Meal])
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
    
    var sortedMeals: [Meal] {
        guard case .loaded(let meals) = state else {
            return []
        }
        
        switch sortOrder {
        case .nameAscending:
            return meals.sorted { $0.name < $1.name}
        case .nameDescending:
            return meals.sorted { $0.name > $1.name}
        }
    }
    
    // MARK: Service Calls
    /// Fetch meals by country / origin
    ///  - Parameters:
    ///    - country: The origin of the meals.
    func fetchMeals(from country: String) async {
        state = .loading
        errorMessage = nil
        
        do {
            let response: MealsResponse = try await self.networkService.fetch(MealsResponse.self, from: .mealByOrigin(country: country))
            
            guard let meals = response.meals else {
                state = .error("No meals found for this origin.")
                return
            }
            
            state = .loaded(meals)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
    
    /// Fetch meals by category.
    /// - Parameters:
    ///    - category: The meal category that needs to be fetched.
    func fetchMeals(with category: String) async {
        state = .loading
        errorMessage = nil
        
        do {
            let response: MealsResponse = try await self.networkService.fetch(MealsResponse.self, from: .mealByCategory(category: category))
            
            guard let meals = response.meals else {
                state = .error("No meals found for this category.")
                return
            }
            
            state = .loaded(meals)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
