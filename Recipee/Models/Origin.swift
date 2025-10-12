//
//  Origins.swift
//  RecipeApp
//
//  Created by Ömer Köse on 11.10.2025.
//

import Foundation

struct Origin: Codable, Identifiable, Sendable {
    let id: UUID = UUID()
    let name: String
    
    var code: String {
        // Map country names to ISO 2-letter codes
        let mapping: [String: String] = [
            "American": "US",
            "British": "GB",
            "Canadian": "CA",
            "Chinese": "CN",
            "Croatian": "HR",
            "Dutch": "NL",
            "Egyptian": "EG",
            "Filipino": "PH",
            "French": "FR",
            "Greek": "GR",
            "Indian": "IN",
            "Irish": "IE",
            "Italian": "IT",
            "Jamaican": "JM",
            "Japanese": "JP",
            "Kenyan": "KE",
            "Malaysian": "MY",
            "Mexican": "MX",
            "Moroccan": "MA",
            "Polish": "PL",
            "Portuguese": "PT",
            "Russian": "RU",
            "Spanish": "ES",
            "Thai": "TH",
            "Tunisian": "TN",
            "Turkish": "TR",
            "Ukrainian": "UA",
            "Uruguayan": "UY",
            "Vietnamese": "VN"
        ]
        return mapping[name] ?? ""
    }
    
    var flagURL: URL? {
        guard !code.isEmpty else { return nil }
        return URL(string: "https://flagcdn.com/w80/\(code.lowercased()).png")
    }
    
    enum CodingKeys: String, CodingKey {
        case name = "strArea"
    }
}

// MARK: - OriginsResponse
struct OriginsResponse: Codable, Sendable {
    let origins: [Origin]?
    
    enum CodingKeys: String, CodingKey {
        case origins = "meals"
    }
}
