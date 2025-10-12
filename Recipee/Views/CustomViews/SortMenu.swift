//
//  SortMenu.swift
//  RecipeApp
//
//  Created by Ömer Köse on 12.10.2025.
//

import SwiftUI

struct SortMenu<T: Equatable>: View {
    @Binding var sortOrder: T
    let options: [(title: String, value: T)]
    
    var body: some View {
        Menu {
            ForEach(options.indices, id: \.self) { index in
                Button {
                    sortOrder = options[index].value
                } label: {
                    Text(sortOrder == options[index].value ? "✓ \(options[index].title)" : options[index].title)
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
    }
}
