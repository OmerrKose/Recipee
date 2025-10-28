//
//  SearchSuggestionsView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

struct SearchSuggestionsView: View {
    @EnvironmentObject var searchViewModel: SearchViewModel
    @Binding var isPresented: Bool
    @State private var showingClearAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text("Recent Searches")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
                
                Spacer()
                
                if !searchViewModel.searchHistory.isEmpty {
                    Button(action: {
                        showingClearAlert = true
                    }) {
                        Text("Clear")
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            
            // History List
            if searchViewModel.searchHistory.isEmpty {
                Text("No recent searches")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 32)
            } else {
                ForEach(searchViewModel.searchHistory, id: \.self) { query in
                    Button(action: {
                        searchViewModel.selectFromHistory(query)
                        isPresented = false
                    }) {
                        HStack(spacing: 12) {
                            Image(systemName: "clock")
                                .foregroundStyle(.secondary)
                                .font(.subheadline)
                            
                            Text(query)
                                .font(.body)
                                .foregroundStyle(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button(action: {
                                withAnimation {
                                    searchViewModel.removeFromHistory(query)
                                }
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                                    .font(.subheadline)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(Color(.secondarySystemBackground))
                    }
                    .buttonStyle(.plain)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(.vertical, 8)
        .alert("Clear Search History", isPresented: $showingClearAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                searchViewModel.clearSearchHistory()
            }
        } message: {
            Text("This will clear all your search history. This action cannot be undone.")
        }
    }
}

#Preview {
    SearchSuggestionsView(isPresented: .constant(true))
        .environmentObject(SearchViewModel())
        .background(Color(.systemBackground))
}
