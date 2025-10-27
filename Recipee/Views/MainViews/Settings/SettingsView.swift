//
//  SettingsView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 12.10.2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("searchHistoryEnabled") private var searchHistoryEnabled = true
    @AppStorage("autoSuggestionsEnabled") private var autoSuggestionsEnabled = true
    
    @EnvironmentObject var searchViewModel: SearchViewModel
    
    @State private var showingClearFavoritesAlert = false
    @State private var showingClearSearchHistoryAlert = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                Form {
                // MARK: - Appearance
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $isDarkMode) {
                        Label("Dark Mode", systemImage: isDarkMode ? "moon.fill" : "sun.max.fill")
                    }
                } //: Section
                .listRowBackground(Color(.systemGray6))
                
                // MARK: - Search & Discovery
                Section(header: Text("Search & Discovery")) {
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
                } //: Section
                .listRowBackground(Color(.systemGray6))
                
                // MARK: - Data Management
                Section(header: Text("Data Management")) {
                    Button(action: {
                        showingClearFavoritesAlert = true
                    }) {
                        Label("Clear All Favorites", systemImage: "heart.slash")
                            .foregroundStyle(.red)
                    }
                } //: Section
                .listRowBackground(Color(.systemGray6))
                
                // MARK: - About
                Section(header: Text("About")) {
                    NavigationLink {
                        AboutView()
                    } label: {
                        Label("About RecipeApp", systemImage: "info.circle")
                    }
                } //: Section
                .listRowBackground(Color(.systemGray6))
                
                // MARK: - Legal
                Section(header: Text("Legal")) {
                    NavigationLink {
                        PrivacyPolicyView()
                    } label: {
                        Label("Privacy Policy", systemImage: "hand.raised")
                    }
                    
                    NavigationLink {
                        TermsOfServiceView()
                    } label: {
                        Label("Terms of Service", systemImage: "doc.text")
                    }
                }//: Section
                .listRowBackground(Color(.systemGray6))
            } //: Form
            .scrollContentBackground(.hidden)
            } //: ZStack
            .navigationTitle("Settings")
            
        } //: NavigationStack
        .alert("Clear All Favorites", isPresented: $showingClearFavoritesAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                // Clear favorites logic
            }
        } message: {
            Text("This will remove all your favorite meals and categories. This action cannot be undone.")
        }
        .alert("Clear Search History", isPresented: $showingClearSearchHistoryAlert) {
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
    SettingsView()
        .environmentObject(SearchViewModel())
}
