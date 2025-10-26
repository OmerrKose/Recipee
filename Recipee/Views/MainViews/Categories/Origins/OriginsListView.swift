//
//  OriginsView.swift
//  RecipeApp
//
//  Created by Ömer Köse on 11.10.2025.
//

import SwiftUI

/// The view that displays origins as list using `OriginsListRowView`
struct OriginsListView: View {
    @EnvironmentObject var viewModel: OriginsViewModel
    
    var body: some View {
        ZStack {
            switch viewModel.state {
            case .idle:
                Color.clear.task { await viewModel.fetchOrigins() }
                
            case .loading:
                ProgressView("Loading...")
                
            case .loaded:
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.sortedOrigins) { origin in
                        NavigationLink {
                            OriginMealsListView(originName: origin.name)
                                .environmentObject(MealViewModel())
                        } label: {
                            OriginsListRowView(origin: origin)
                                .padding(.horizontal, 8)
                        }
                        .buttonStyle(.plain)
                        
                    } //: Loop
                } //: LazyVStack
                
            case .error(let message):
                ServiceErrorView(message: message) {
                    await viewModel.fetchOrigins()
                }
                
            } //: Switch
        } //: ZStack
        .background(Color(.secondarySystemBackground))
        .navigationTitle("Origins")
        .withSettings()
        .toolbar {
            SortMenu(
                sortOrder: $viewModel.sortOrder,
                options: [
                    ("Name A-Z", .nameAscending),
                    ("Name Z-A", .nameDescending)
                ]
            )
        }
        .task {
            if case .idle = viewModel.state {
                await viewModel.fetchOrigins()
            }
        }
    }
}

#Preview {
    NavigationStack {
        OriginsListView()
            .environmentObject(OriginsViewModel())
    }
}
