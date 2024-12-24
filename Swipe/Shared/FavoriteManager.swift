//
//  FavoriteManager.swift
//  Swipe
//
//  Created by Arjun Pratap Choudhary on 23/12/24.
//

import Foundation
import SwiftData

class FavoriteManager {
    private var modelContext: ModelContext

    // Initialize with a model context
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func saveFavorite(product: Product) {
        let favorite = FavoritedProduct(
            id: product.id,
            productName: product.productName,
            productType: product.productType,
            price: product.price,
            imageUrl: product.image
        )
        modelContext.insert(favorite)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save favorite: \(error)")
        }
    }

    func removeFavorite(product: Product) {
        if let existing = fetchFavorite(productId: product.id) {
            modelContext.delete(existing)
            do {
                try modelContext.save()
            } catch {
                print("Failed to remove favorite: \(error)")
            }
        }
    }

    func fetchFavorite(productId: UUID) -> FavoritedProduct? {
        let descriptor = FetchDescriptor<FavoritedProduct>(
            predicate: #Predicate { $0.id == productId }
        )
        return try? modelContext.fetch(descriptor).first
    }
}
