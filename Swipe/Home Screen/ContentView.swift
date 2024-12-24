//
//  ContentView.swift
//  Swipe
//
//  Created by Arjun Pratap Choudhary on 23/12/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ProductViewModel()
    @State private var navigateToAddProductScreen = false
    @State private var loadingProgress: CGFloat = 0.0 // Progress value for the loader
    @State private var refreshID = UUID() // Unique ID for refreshing LazyVStack
    
    // Add a separate AddProductViewModel to handle offline uploads
    @StateObject private var addProductVM = AddProductViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 16) {
                    // Header with Products Title and Sort Button
                    HStack {
                        Text("Products")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.leading)

                        Spacer()

                        // Sort Menu Button
                        Menu {
                            Button("Price: Low to High") {
                                viewModel.changeSorting(to: .priceLowToHigh)
                            }
                            Button("Price: High to Low") {
                                viewModel.changeSorting(to: .priceHighToLow)
                            }
                            Button("Name: A-Z") {
                                viewModel.changeSorting(to: .nameAZ)
                            }
                            Button("Name: Z-A") {
                                viewModel.changeSorting(to: .nameZA)
                            }
                            Button("Type") {
                                viewModel.changeSorting(to: .type)
                            }
                        } label: {
                            Image(systemName: "arrow.up.arrow.down.circle")
                                .foregroundColor(.white)
                                .scaleEffect(2.0)
                        }
                        .padding(.trailing)
                    }
                    .padding(.top, 16)

                    // Loading Progress Indicator (Horizontal Bar)
                    if viewModel.loading {
                        ProgressBar(progress: loadingProgress)
                            .frame(height: 10)
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                    }

                    // Custom Search Bar
                    HStack {
                        Image("searchIcon") // Custom Search Icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .padding(.leading, 8)

                        TextField("Search products...", text: $viewModel.searchQuery)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 8)
                            .background(Color.clear)

                        if !viewModel.searchQuery.isEmpty {
                            Button(action: {
                                viewModel.searchQuery = ""
                            }) {
                                Image("clearIcon") // Custom Clear Icon
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color(red: 50 / 255, green: 50 / 255, blue: 50 / 255))
                    )
                    .padding(.horizontal)

                    // Product List with Pull-to-Refresh
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.filteredProducts) { product in
                                ProductCardView(product: product, viewModel: viewModel)
                            }
                        }
                        .padding(.horizontal)
                        .id(refreshID) // Use refreshID to force reload
                        .refreshable {
                            // Pull-to-Refresh Handler
                            viewModel.fetchProducts() // Reload products
                            refreshID = UUID() // Regenerate LazyVStack to force refresh
                        }
                    }
                }
                .navigationTitle("")         // Remove navigation bar title
                .foregroundColor(.white)     // White text for navigation
                .background(Color.black.ignoresSafeArea())

                // Floating Add Product Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            navigateToAddProductScreen = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.black)
                                    .frame(width: 65, height: 65)
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .scaleEffect(2.5)
                            }
                            .shadow(radius: 5)
                        }
                        .padding()
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToAddProductScreen) {
                AddProductView(onProductAdded: {
                    viewModel.fetchProducts() // Refresh products after adding
                })
            }
            // Call this once the view appears
            .onAppear {
                startLoadingProgress()
                viewModel.fetchProducts()
            }
            // Watch for network changes. If we reconnect, upload offline products.
            .onReceive(NetworkMonitor.shared.$isConnected) { isConnected in
                if isConnected {
                    addProductVM.uploadOfflineProducts()
                }
            }
        }
    }

    private func startLoadingProgress() {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if viewModel.loading && loadingProgress < 1.0 {
                loadingProgress += 0.02
            } else {
                timer.invalidate()
            }
        }
    }
}

// MARK: - ProgressBar View
struct ProgressBar: View {
    var progress: CGFloat

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: geometry.size.height)
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white)
                    .frame(width: geometry.size.width * progress, height: geometry.size.height)
            }
        }
    }
}

// MARK: - Placeholder Modifier (if needed)
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}
