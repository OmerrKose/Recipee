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
    @AppStorage("searchHistoryEnabled") private var searchHistoryEnabled = true
    @State private var isSuggestionsPresented = true
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Content
                if searchViewModel.isLoading {
                    LoadingView("Searching...", fullScreen: false)
                        .frame(minHeight: 400)
                } else if !searchViewModel.hasSearched {
                    ScrollView {
                        VStack(spacing: 24) {
                            EmptySearchView()
                            if searchHistoryEnabled && !searchViewModel.searchHistory.isEmpty {
                                SearchSuggestionsView(isPresented: $isSuggestionsPresented)
                            }
                        }
                    }
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
            .onChange(of: searchViewModel.searchText) { oldValue, newValue in
                isSuggestionsPresented = newValue.isEmpty
                // If user clears the search text, reset to base view
                if newValue.isEmpty {
                    searchViewModel.clearSearch()
                }
            }
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(SearchViewModel())
        .environmentObject(FavoritesViewModel())
}
