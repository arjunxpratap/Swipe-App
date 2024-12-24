//
//  ProductViewModel.swift
//  Swipe
//
//  Created by Arjun Pratap Choudhary on 23/12/24.
//

import Foundation
import Combine

class ProductViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var searchQuery = ""
    @Published var loading = false
    @Published var sortOption: SortOption = .none

    private var cancellables = Set<AnyCancellable>()

    enum SortOption {
        case none
        case priceLowToHigh
        case priceHighToLow
        case nameAZ
        case nameZA
        case type
    }

    init() {
        loadFavorites()  // Load saved favorite products
        fetchProducts()  // Fetch products from API
    }

    func fetchProducts() {
        loading = true
        guard let url = URL(string: "https://app.getswipe.in/api/public/get") else {
            print("Invalid URL")
            loading = false
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Product].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .receive(on: DispatchQueue.main)
            .sink { [weak self] fetchedProducts in
                guard let self = self else { return }
                self.products = fetchedProducts
                self.applyFavorites() // Apply favorites to fetched products
                self.sortProducts()   // Sort products to show favorites on top
                self.loading = false
            }
            .store(in: &cancellables)
    }

    func sortProducts() {
        let favoritedProducts = products.filter { $0.isFavorite }
        var nonFavoritedProducts = products.filter { !$0.isFavorite }

        switch sortOption {
        case .none:
            break
        case .priceLowToHigh:
            nonFavoritedProducts.sort { $0.price < $1.price }
        case .priceHighToLow:
            nonFavoritedProducts.sort { $0.price > $1.price }
        case .nameAZ:
            nonFavoritedProducts.sort {
                $0.productName.localizedCaseInsensitiveCompare($1.productName) == .orderedAscending
            }
        case .nameZA:
            nonFavoritedProducts.sort {
                $0.productName.localizedCaseInsensitiveCompare($1.productName) == .orderedDescending
            }
        case .type:
            nonFavoritedProducts.sort {
                $0.productType.localizedCaseInsensitiveCompare($1.productType) == .orderedAscending
            }
        }

        // Combine favorited and sorted non-favorited products
        products = favoritedProducts + nonFavoritedProducts
    }

    func changeSorting(to newSortOption: SortOption) {
        sortOption = newSortOption
        sortProducts()
    }

    var filteredProducts: [Product] {
        if searchQuery.isEmpty {
            return products
        } else {
            return products.filter {
                $0.productName.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }

    func toggleFavorite(for product: Product) {
        if let index = products.firstIndex(where: { $0.id == product.id }) {
            products[index].isFavorite.toggle()
            print("DEBUG: Toggled '\(products[index].productName)' favorite to \(products[index].isFavorite)")
            saveFavorites()
            sortProducts()
        }
    }

    private func saveFavorites() {
        let favoriteProducts = products.filter { $0.isFavorite }
        print("DEBUG: Saving \(favoriteProducts.count) favorites.")
        JSONStorageManager.shared.saveFavorites(favoriteProducts)
    }

    private func loadFavorites() {
        let favoriteProducts = JSONStorageManager.shared.loadFavorites()
        print("DEBUG: Loaded \(favoriteProducts.count) favorites from disk.")

        // Match loaded favorites to current products by productName (instead of UUID).
        for favorite in favoriteProducts {
            if let index = products.firstIndex(where: { $0.productName == favorite.productName }) {
                products[index].isFavorite = true
                print("DEBUG: Matched & marked favorite -> \(products[index].productName)")
            }
        }
    }

    private func applyFavorites() {
        print("DEBUG: Applying favorites to newly fetched products.")
        loadFavorites()
    }
}
