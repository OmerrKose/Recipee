//
//  NetworkLayer.swift
//  RecipeApp
//
//  Created by Ömer Köse on 30.09.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case requestFailed(Error)
    case decodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "The URL is invalid"
        case .invalidResponse:
            return "The server response was invalid"
        case .requestFailed(let error):
            return "Network request failed: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}

protocol NetworkServiceProtocol {
    nonisolated func fetch<T: Decodable>(_ T: T.Type, from endpoint: MealDBEndpoint) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    nonisolated func fetch<T>(_ T: T.Type, from endpoint: MealDBEndpoint) async throws -> T where T : Decodable {
        guard let url = endpoint.url else {
            throw NetworkError.invalidUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
            
        } catch {
            throw NetworkError.decodingFailed(error)
            
        }
    }
}
