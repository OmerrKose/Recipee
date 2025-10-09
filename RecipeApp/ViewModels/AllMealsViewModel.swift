//
//  AllMealsViewModel.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import Foundation
import Combine

class AllMealsViewModel: ObservableObject {
    enum LoadingState {
        case idle
        case loading
        case loaded([Meal])
        case error(String)
    }
    
    @Published var meals: [Meal] = []
    @Published var state: LoadingState = .idle
    @Published var errorMessage: String?
    
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchMeals(startingWith letter: String = "b") async {
        state = .idle
        errorMessage = nil
        
        do {
            let response: MealsResponse = try await self.networkService.fetch(
                MealsResponse.self,
                from: .allMeals(letter: letter)
            )
            
            guard let meals = response.meals else {
                state = .error("No meals found")
                return
            }
            
            state = .loaded(meals)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
