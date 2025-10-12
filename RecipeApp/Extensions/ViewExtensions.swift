//
//  ViewExtensions.swift
//  RecipeApp
//
//  Created by Ömer Köse on 12.10.2025.
//

import SwiftUI

extension View {
    /// Adds setings toolbar as a button.
    func withSettings() -> some View {
        modifier(SettingsToolbarModifier())
    }
}
