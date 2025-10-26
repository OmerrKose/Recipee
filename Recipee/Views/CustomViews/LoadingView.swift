//
//  LoadingView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

struct LoadingView: View {
    let message: String
    let fullScreen: Bool
    
    init(_ message: String = "Loading...", fullScreen: Bool = true) {
        self.message = message
        self.fullScreen = fullScreen
    }
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.8)
                .tint(.accentColor)
            
            Text(message)
                .font(.headline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: fullScreen ? .infinity : nil)
        .background(fullScreen ? Color(.systemBackground) : Color.clear)
        .if(fullScreen) { view in
            view.ignoresSafeArea()
        }
    }
}

// Extension to conditionally apply modifiers
extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

#Preview {
    LoadingView("Loading meals...")
}
