//
//  ColorExtensions.swift
//  RecipeApp
//
//  Created by Ömer Köse on 8.10.2025.
//

import SwiftUI

extension Color {
    // Method to randomly give text background color
    static func colorForTag(_ tag: String) -> Color {
        let colors: [Color] = [
            .blue, .green, .orange, .purple, .pink,
            .red, .indigo, .teal, .mint, .cyan
        ]
        let index = abs(tag.hashValue) % colors.count
        return colors[index]
    }
}
