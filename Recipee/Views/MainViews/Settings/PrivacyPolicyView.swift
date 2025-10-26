//
//  PrivacyPolicyView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy Policy")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Last updated: October 2025")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("Your privacy is important to us. This app does not collect personal information and only stores your preferences locally on your device.")
                    .font(.body)
                
                Text("Data Collection")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("We do not collect, store, or transmit any personal data. All your favorites and preferences are stored locally on your device.")
                    .font(.body)
                
                Text("Third-Party Services")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("This app uses TheMealDB API for recipe data. Please review their privacy policy for information about their data practices.")
                    .font(.body)
            }
            .padding()
            } //: ScrollView
        } //: ZStack
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PrivacyPolicyView()
    }
}
