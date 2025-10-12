//
//  ServiceErrorView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 11.10.2025.
//

import SwiftUI

struct ServiceErrorView: View {
    let message: String
    let buttonAction: () async -> Void
    
    var body: some View {
        ContentUnavailableView(
            "Something went wrong.",
            systemImage: "exclamationmark.triangle.fill"
        )
        .overlay(alignment: .bottom) {
            Button {
                Task {
                    await buttonAction()
                }
            } label: {
                Text("Try again")
            }
            .buttonStyle(.borderedProminent)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    ServiceErrorView(message: "Error", buttonAction: { })
}
