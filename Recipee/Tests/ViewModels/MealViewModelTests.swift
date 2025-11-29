//
//  MealViewModelTests.swift
//  RecipeAppTests
//
//  Created by Ömer Köse on 22.11.2025.
//

import XCTest
@testable import Recipee

@MainActor
final class MealViewModelTests: XCTestCase {
    var sut: MealViewModel!
    var mockService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
        sut = MealViewModel(networkService: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchMealsByOrigin_Success() async {
        // Given
        let meals = [
            Meal(id: "1", name: "Kebab", thumbnailString: "url"),
            Meal(id: "2", name: "Baklava", thumbnailString: "url")
        ]
        let response = MealsResponse(meals: meals)
        mockService.result = .success(response)
        
        // When
        await sut.fetchMeals(from: "Turkish")
        
        // Then
        if case .loaded(let loadedMeals) = sut.state {
            XCTAssertEqual(loadedMeals.count, 2)
            XCTAssertEqual(loadedMeals.first?.name, "Kebab")
        } else {
            XCTFail("Expected loaded state")
        }
    }
    
    func testFetchMealsByOrigin_Failure() async {
        // Given
        mockService.result = .failure(NetworkError.serverError(statusCode: 500))
        
        // When
        await sut.fetchMeals(from: "Turkish")
        
        // Then
        if case .error(let message) = sut.state {
            XCTAssertTrue(message.contains("Server returned an error"))
        } else {
            XCTFail("Expected error state")
        }
    }
    
    func testFetchMealsByOrigin_Empty() async {
        // Given
        let response = MealsResponse(meals: nil)
        mockService.result = .success(response)
        
        // When
        await sut.fetchMeals(from: "Turkish")
        
        // Then
        if case .error(let message) = sut.state {
            XCTAssertEqual(message, "No meals found for this origin.")
        } else {
            XCTFail("Expected error state for empty meals")
        }
    }
}
