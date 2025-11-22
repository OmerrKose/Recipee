//
//  SearchViewModelTests.swift
//  RecipeAppTests
//
//  Created by Ömer Köse on 22.11.2025.
//

import XCTest
@testable import Recipee

@MainActor
final class SearchViewModelTests: XCTestCase {
    var sut: SearchViewModel!
    var mockService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockService = MockNetworkService()
        sut = SearchViewModel(networkService: mockService)
    }
    
    override func tearDown() {
        sut = nil
        mockService = nil
        super.tearDown()
    }
    
    func testClearSearch() {
        // Given
        sut.searchText = "Test"
        sut.hasSearched = true
        sut.isLoading = true
        
        // When
        sut.clearSearch()
        
        // Then
        XCTAssertTrue(sut.searchText.isEmpty)
        XCTAssertFalse(sut.hasSearched)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.suggestions.isEmpty)
    }
    
    func testCommitSearch_EmptyQuery() {
        // Given
        sut.searchText = "   "
        
        // When
        sut.commitSearch()
        
        // Then
        XCTAssertFalse(sut.hasSearched)
    }
}
