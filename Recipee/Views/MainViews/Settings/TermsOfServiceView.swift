//
//  TermsOfServiceView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

struct TermsOfServiceView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Terms of Service")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Last updated: October 2025")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    
                    Text("By using RecipeApp, you agree to these terms of service.")
                        .font(.body)
                    
                    Text("Use License")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("This app is provided for personal, non-commercial use. You may not redistribute or modify the app without permission.")
                        .font(.body)
                    
                    Text("Disclaimer")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("The recipe information is provided by third-party sources. We are not responsible for the accuracy of recipe data.")
                        .font(.body)
                }
                .padding()
            } //: ScrollView
        } //: ZStack
        .navigationTitle("Terms of Service")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TermsOfServiceView()
    }
}
