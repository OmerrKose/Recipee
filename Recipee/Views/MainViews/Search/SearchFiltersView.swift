//
//  SearchFiltersView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 1.10.2025.
//

import SwiftUI

struct SearchFiltersView: View {
    // MARK: - Properties
    @AppStorage("searchHistoryEnabled") private var searchHistoryEnabled = true
    @AppStorage("autoSuggestionsEnabled") private var autoSuggestionsEnabled = true
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var showingClearSearchHistoryAlert = false
    
    var body: some View {
        ZStack { //: ZStack
            Color(.systemBackground)
                .ignoresSafeArea()
            
            Form {
                Section {
                    Toggle(isOn: $searchViewModel.filterFavorites) {
                        Label("Favorites", systemImage: "heart.fill")
                    }
                    
                    Toggle(isOn: $searchViewModel.filterCategories) {
                        Label("Categories", systemImage: "square.grid.2x2")
                    }
                    
                    Toggle(isOn: $searchViewModel.filterOrigins) {
                        Label("Origins", systemImage: "flag")
                    }
                    
                    Toggle(isOn: $searchViewModel.filterMeals) {
                        Label("Meals", systemImage: "fork.knife")
                    }
                    
                    Toggle(isOn: $searchViewModel.filterIngredients) {
                        Label("Ingredients", systemImage: "leaf.fill")
                    }
                } header: {
                    Text("Filter Search Results")
                } footer: {
                    Text("Select which types of content to include in your search results.")
                }
                .listRowBackground(Color(.systemGray6))
                
                // MARK: - Search & Discovery
                Section {
                    Toggle(isOn: $searchHistoryEnabled) {
                        Label("Search History", systemImage: "clock")
                    }
                    .onChange(of: searchHistoryEnabled) { oldValue, newValue in
                        // Clear history when disabled
                        if !newValue {
                            searchViewModel.clearSearchHistory()
                        }
                    }
                    
                    Toggle(isOn: $autoSuggestionsEnabled) {
                        Label("Auto-suggestions", systemImage: "text.bubble")
                    }
                    
                    Button(action: {
                        showingClearSearchHistoryAlert = true
                    }) {
                        Label("Clear Search History", systemImage: "trash")
                            .foregroundStyle(.red)
                    }
                    .disabled(!searchHistoryEnabled)
                } header: {
                    Text("Search Settings")
                } footer: {
                    Text("Adjust your search experience.")
                }
                .listRowBackground(Color(.systemGray6))
            } //: Form
            .scrollContentBackground(.hidden)
        } //: ZStack
        .navigationTitle("Search Filters")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Clear Search History", isPresented: $showingClearSearchHistoryAlert) { //: alert
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                searchViewModel.clearSearchHistory()
            }
        } message: {
            Text("This will clear all your search history. This action cannot be undone.")
        } //: alert
        .toolbar { //: toolbar
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        } //: toolbar
    } //: Body
}

#Preview {
    NavigationStack {
        SearchFiltersView()
            .environmentObject(SearchViewModel())
    }
}

