//
//  SearchSectionView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

struct SearchSectionView<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: Content
    let itemCount: Int?
    
    @State private var isExpanded: Bool
    
    init(title: String, icon: String, color: Color, itemCount: Int? = nil, initiallyExpanded: Bool = false, @ViewBuilder content: () -> Content) {
        self.title = title
        self.icon = icon
        self.color = color
        self.itemCount = itemCount
        self.content = content()
        self._isExpanded = State(initialValue: initiallyExpanded)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: icon)
                        .foregroundStyle(color)
                        .font(.title3)
                        .frame(width: 24)
                    
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.primary)
                    
                    if let count = itemCount {
                        Text("(\(count))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 12)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            
            if isExpanded {
                content
            }
        }
    }
}

#Preview {
    SearchSectionView(
        title: "Sample Section",
        icon: "star.fill",
        color: .yellow
    ) {
        Text("Sample content goes here")
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    .padding()
}
