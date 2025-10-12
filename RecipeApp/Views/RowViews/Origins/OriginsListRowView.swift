//
//  OriginsListRowView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 11.10.2025.
//

import SwiftUI

/// List element to display origin.
struct OriginsListRowView: View {
    var origin: Origin
    
    var body: some View {
        HStack(spacing: 16) {
            // Flag with better fallback
            AsyncImage(url: origin.flagURL) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Circle()
                            .fill(Color(.secondarySystemBackground))
                        ProgressView()
                    }
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(.systemGray5), Color(.systemGray6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                    }
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 56, height: 56)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color(.systemGray5).opacity(0.3), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            
            // Country name
            Text(origin.name)
                .font(.headline)
                .foregroundStyle(.primary)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    OriginsListRowView(origin: Origin(name: "Ukrainian"))
}
