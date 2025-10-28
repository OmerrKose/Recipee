//
//  TitleAndExplanationView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 8.10.2025.
//

import SwiftUI

/// A horizontal view that displays an optional SF Symbol image, a title, and an explanation text.
///
/// - Parameters:
///   - imageName: The name of the SF Symbol to display. If `nil`, no image is shown.
///   - title: The main title text.
///   - explanation: The secondary explanation text.
///   - link: If provided turns title into link with given url.
///   - iconColor: Optional color for the icon
/// - Note: When link is provided, only the title becomes clickable
///
/// Example usage:
/// ```swift
/// TitleAndExplanationView(imageName: "star.fill", title: "Rating", explanation: "4.5/5")
/// ```
struct TitleAndExplanationView: View {
    var title: String
    var explanation: String?
    var imageName: String?
    var link: String?
    var iconColor: Color?
    
    var body: some View {
        HStack(spacing: 8) {
            
            // Image
            if let image = imageName {
                Image(systemName: image)
                    .font(.title3)
                    .foregroundStyle(iconColor ?? .secondary)
            }
            
            // Title
            if let link = link, let url = URL(string: link) {
                Link(title, destination: url)
                    .fontWeight(.bold)
                
            } else {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                
                // Explanation (on same line if provided)
                if let explanation = explanation, !explanation.isEmpty {
                    Text(explanation)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
        } //: HStack
    } //: Body
}

#Preview {
    TitleAndExplanationView(title: "title", explanation: "explanation", imageName: "globe", link: "https:google.com")
}
