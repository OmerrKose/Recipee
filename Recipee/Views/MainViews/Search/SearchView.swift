//
//  SearchView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var searchViewModel: SearchViewModel
    @EnvironmentObject var favoritesViewModel: FavoritesViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Content
                if searchViewModel.isLoading {
                    LoadingView("Searching...", fullScreen: false)
                        .frame(minHeight: 400)
                } else if !searchViewModel.hasSearched {
                    EmptySearchView()
                } else if searchViewModel.searchResults.isEmpty {
                    EmptySearchResultsView()
                } else {
                    SearchResultsView(searchResults: searchViewModel.searchResults)
                }
            }
            .background(Color(.systemBackground))
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                searchViewModel.favoritesViewModel = favoritesViewModel
            }
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(SearchViewModel())
        .environmentObject(FavoritesViewModel())
}
