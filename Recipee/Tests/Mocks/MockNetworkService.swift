//
//  MockNetworkService.swift
//  RecipeAppTests
//
//  Created by Ömer Köse on 22.11.2025.
//

import Foundation
@testable import Recipee

class MockNetworkService: NetworkServiceProtocol {
    var result: Result<Decodable, Error>?
    
    func fetch<T>(_ T: T.Type, from endpoint: MealDBEndpoint) async throws -> T where T : Decodable {
        guard let result = result else {
            fatalError("Mock result not set")
        }
        
        switch result {
        case .success(let data):
            guard let typedData = data as? T else {
                fatalError("Mock data type mismatch")
            }
            return typedData
        case .failure(let error):
            throw error
        }
    }
}
