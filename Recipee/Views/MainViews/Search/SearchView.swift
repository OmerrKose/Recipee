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
    @State private var showingFilters = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Show suggestions if enabled and available (even when searching)
                if !searchViewModel.searchText.isEmpty && !searchViewModel.suggestions.isEmpty {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Suggestions")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 16)
                                .padding(.top, 8)
                            
                            ForEach(searchViewModel.suggestions, id: \.self) { suggestion in
                                Button {
                                    searchViewModel.searchText = suggestion
                                    searchViewModel.commitSearch()
                                } label: {
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundStyle(.secondary)
                                        Text(suggestion)
                                            .foregroundStyle(.primary)
                                        Spacer()
                                    } //: HStack
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    .background(Color(.secondarySystemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                } //: Button
                                .buttonStyle(.plain)
                            } //: ForEach
                        } //: VStack
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .padding(.bottom, 16)
                    } //: ScrollView
                    .frame(maxHeight: 200) // Limit height and allow scrolling
                    .fixedSize(horizontal: false, vertical: true)
                }
                
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
                        } //: VStack
                    } //: ScrollView
                } else if searchViewModel.searchResults.isEmpty {
                    EmptySearchResultsView()
                } else {
                    SearchResultsView(searchResults: searchViewModel.searchResults)
                        .padding(.top, searchViewModel.suggestions.isEmpty ? 0 : 8)
                }
            } //: VStack
            .background(Color(.systemBackground))
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingFilters = true
                    } label: {
                        Label("Filters", systemImage: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                NavigationStack {
                    SearchFiltersView()
                        .environmentObject(searchViewModel)
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
            .onAppear {
                searchViewModel.favoritesViewModel = favoritesViewModel
            } //: onAppear
            .onChange(of: searchViewModel.searchText) { oldValue, newValue in
                isSuggestionsPresented = newValue.isEmpty
                // If user clears the search text, reset to base view
                if newValue.isEmpty {
                    searchViewModel.clearSearch()
                } else {
                    // Generate suggestions as user types
                    searchViewModel.generateSuggestions(for: newValue)
                }
            } //: onChange
            .onChange(of: showingFilters) { _, isShowing in
                // Re-search when filter sheet is dismissed
                if !isShowing && searchViewModel.hasSearched {
                    searchViewModel.commitSearch()
                }
            } //: onChange
        } //: NavigationStack
    } //: Body
}

#Preview {
    SearchView()
        .environmentObject(SearchViewModel())
        .environmentObject(FavoritesViewModel())
}
