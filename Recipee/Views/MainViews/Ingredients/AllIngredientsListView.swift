//
//  AllIngredientsListView.swift
//  Recipee
//
//  Created by Ömer Köse on 28.10.2025.
//

import SwiftUI

struct AllIngredientsListView: View {
    @EnvironmentObject var viewModel: IngredientsViewModel
    
    // Alphabet for the side index - static A-Z for visual reference
    private let alphabet = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W", "X","Y", "Z"]
    
    // Sorted alphabet based on current sort order
    private var sortedAlphabet: [String] {
        switch viewModel.sortOrder {
        case .nameAscending:
            return alphabet
        case .nameDescending:
            return alphabet.reversed()
        }
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            switch viewModel.state {
            case .idle:
                Color.clear
                
            case .loading:
                LoadingView("Loading origins...", fullScreen: false)
                    .frame(minHeight: 400)
                
            case .loaded(let ingredients):
                if ingredients.isEmpty {
                        ContentUnavailableView(
                            "No Ingredients",
                            systemImage: "fork.knife",
                            description: Text("There are no ingredients available at the moment.")
                        )
                } else {
                    ScrollViewReader { proxy in
                        ZStack {
                            ScrollView {
                                LazyVStack(spacing: 0) {
                                    // Top anchor
                                    Color.clear
                                        .frame(height: 0)
                                        .id("top")
                                    
                                    ForEach(viewModel.groupedIngredients, id: \.0) { letter, ingredientsForLetter in
                                        if !ingredientsForLetter.isEmpty {
                                            // Letter header
                                            Text(letter)
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(.secondary)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .padding(.horizontal, 16)
                                                .padding(.vertical, 8)
                                                .background(Color(.systemBackground))
                                            
                                            // Ingredients for this letter
                                            ForEach(ingredientsForLetter) { ingredient in
                                                NavigationLink {
                                                    IngredientDetailView(ingredient: ingredient)
                                                } label: {
                                                    IngredientRowView(ingredient: ingredient)
                                                } //: NavigationLink
                                                .buttonStyle(.plain)
                                                .padding(.bottom, 12)
                                            } //: ForEach
                                            .padding(.horizontal, 16)
                                            .id(letter)
                                        }
                                    } //: ForEach
                                    
                                    // Bottom anchor
                                    Color.clear
                                        .frame(height: 0)
                                        .id("bottom")
                                } //: LazyVStack
                                .padding(.vertical, 8)
                                .padding(.trailing, 16) // Add padding to prevent overlap with alphabet index
                            } //: ScrollView
                            
                            // Side alphabet index
                            HStack {
                                    Spacer()
                                    VStack(spacing: 2) {
                                        // Top button
                                        Button(action: {
                                            withAnimation {
                                                proxy.scrollTo("top", anchor: .top)
                                            }
                                        }) {
                                            Image(systemName: "chevron.up")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundStyle(.primary)
                                                .frame(width: 18, height: 14)
                                        } //: Button
                                        
                                        Divider()
                                            .frame(width:2 ,height: 4)
                                        
                                        ForEach(0..<sortedAlphabet.count, id: \.self) { index in
                                            let letter = sortedAlphabet[index]
                                            let isAvailable = viewModel.availableLetters.contains(letter)
                                            
                                            Button(action: {
                                                withAnimation {
                                                    proxy.scrollTo(letter, anchor: .top)
                                                }
                                            }) {
                                                Text(letter)
                                                    .font(.system(size: 11, weight: .medium))
                                                    .foregroundStyle(isAvailable ? .primary : .tertiary)
                                                    .frame(width: 18, height: 14)
                                            } //: Button
                                            .disabled(!isAvailable)
                                        } //: ForEach
                                        
                                        Divider()
                                            .frame(width:2 ,height: 4)
                                        
                                        // Bottom button
                                        Button(action: {
                                            withAnimation {
                                                proxy.scrollTo("bottom", anchor: .bottom)
                                            }
                                        }) {
                                            Image(systemName: "chevron.down")
                                                .font(.system(size: 10, weight: .bold))
                                                .foregroundStyle(.primary)
                                                .frame(width: 18, height: 14)
                                        } //: Button
                                    } //: VStack
                                    .padding(.trailing, 4)
                                } //: HStack
                            } //: ZStack
                        } //: ScrollViewReader
                    }
                    
            case .error(let message):
                    ServiceErrorView(message: message) {
                        await viewModel.fetchIngredients()
                    } //: ServiceErrorView
            } //: switch
        } //: ZStack
        .navigationTitle("Ingredients")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            viewModel.sortOrder = .nameAscending
                        }) {
                            Label("A-Z", systemImage: viewModel.sortOrder == .nameAscending ? "checkmark" : "")
                        } //: Button
                        
                        Button(action: {
                            viewModel.sortOrder = .nameDescending
                        }) {
                            Label("Z-A", systemImage: viewModel.sortOrder == .nameDescending ? "checkmark" : "")
                        } //: Button
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    } //: Menu
            } //: ToolbarItem
        } //: Toolbar
        .task {
            if case .idle = viewModel.state {
                Task.detached(priority: .userInitiated) {
                    await viewModel.fetchIngredients()
                }
            }
        }
    } //: Body
}

#Preview {
    NavigationStack {
        AllIngredientsListView()
            .environmentObject(IngredientsViewModel())
    }
}
