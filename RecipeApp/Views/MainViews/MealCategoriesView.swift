//
//  CategoriesView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 30.09.2025.
//

import SwiftUI

struct MealCategoriesView: View {
    @EnvironmentObject var viewModel: MealCategoriesViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                switch viewModel.state {
                case .idle:
                    Color.clear.task { await viewModel.fetchCategories() }
                    
                case .loading:
                    ProgressView("Loading...")
                    
                case .loaded:
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 20) {
                            ForEach(viewModel.sortedCategories) { category in
                                CategoriesRowView(category: category)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .scrollIndicators(.hidden)
                    
                case .error(let message):
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(.red)
                        
                        Text("An error occured")
                            .font(.headline)
                        
                        Text(message)
                            .font(.caption)
                            .foregroundStyle(Color.secondary)
                        
                        Button("Retry") {
                            Task {
                                await viewModel.fetchCategories()
                            }
                        }
                    } //: VStack
                    .frame(maxWidth: .infinity)
                    
                } //: Switch
            } //: ZStack
            .navigationTitle("Categories")
            .toolbarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Section {
                            Button {
                                viewModel.sortOrder = .nameAscending
                            } label: {
                                HStack {
                                    Text("Name (A-Z)")
                                    
                                    if viewModel.sortOrder == .nameAscending {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                            
                            Button {
                                viewModel.sortOrder = .nameDescending
                            } label: {
                                HStack {
                                    Text("Name (Z-A)")
                                    
                                    if viewModel.sortOrder == .nameDescending {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        } //: Section
                    } label: {
                        Label("Menu", systemImage: "arrow.up.arrow.down")
                    } //: Menu
                } //: ToolbarItem
            }
            .task {
                if case .idle = viewModel.state {
                    await viewModel.fetchCategories()
                }
            }
        } //: NavigationStack
    }
}

#Preview {
    MealCategoriesView()
        .environmentObject(MealCategoriesViewModel())
}
