//
//  Product.swift
//  Swipe
//
//  Created by Arjun Pratap Choudhary on 23/12/24.
//
import Foundation

struct Product: Identifiable, Codable {
    var id = UUID()
    var productName: String
    var productType: String
    var price: Double
    var tax: Double
    var image: String?  // Image URL if available
    var isFavorite: Bool = false  // Track favorite status

    var imageUrl: URL? {
        guard let image = image, !image.isEmpty else { return nil }
        return URL(string: image)
    }

    enum CodingKeys: String, CodingKey {
        case productName = "product_name"
        case productType = "product_type"
        case price
        case tax
        case image
    }
}
