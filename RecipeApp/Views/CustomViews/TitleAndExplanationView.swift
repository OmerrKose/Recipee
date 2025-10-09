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
///
/// Example usage:
/// ```swift
/// InfoRowView(imageName: "star.fill", title: "Rating", explantion: "4.5/5")
/// ```
struct TitleAndExplanationView: View {
    var title: String
    var explanation: String?
    var imageName: String?
    var link: String?
    
    var body: some View {
        HStack(spacing: 8) {
            
            // Image
            if let image = imageName {
                Image(systemName: image)
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            // Title
            if let link = link, let url = URL(string: link) {
                Link(title, destination: url)
                    .fontWeight(.bold)
                
            } else {
                Text(title)
                    .font(.callout)
                    .fontWeight(.medium)
                
                // Explanation
                if let explanation = explanation {
                    Text(explanation)
                        .font(.callout)
                        .fontWeight(.light)
                }
            }
        }
    }
}

#Preview {
    TitleAndExplanationView(title: "title", explanation: "explanation", imageName: "globe", link: "https:google.com")
}
