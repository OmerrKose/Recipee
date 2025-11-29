//
//  LetterSelectorView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

struct LetterSelectorView: View {
    @Binding var selectedLetter: String
    let letters = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(letters, id: \.self) { letter in
                    Button(action: {
                        selectedLetter = letter.lowercased()
                    }) {
                        Text(letter)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundStyle(selectedLetter.uppercased() == letter ? .white : .primary)
                            .frame(width: 40, height: 40)
                            .background(
                                Circle()
                                    .fill(selectedLetter.uppercased() == letter ? Color.accentColor : Color(.systemGray6))
                            )
                            .scaleEffect(selectedLetter.uppercased() == letter ? 1.1 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: selectedLetter)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Meals starting with \(letter)")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12) // Added vertical padding for the circles
        }
        .frame(height: 64) // Fixed height to accommodate scaled circles
    }
}

#Preview {
    @Previewable @State var selectedLetter = "a"
    return LetterSelectorView(selectedLetter: $selectedLetter)
        .background(Color(.systemBackground))
}
