//
//  FavoritedProduct.swift
//  Swipe
//
//  Created by Arjun Pratap Choudhary on 23/12/24.
//


import Foundation
import SwiftData

@Model
class FavoritedProduct {
    @Attribute(.unique) var id: UUID
    var productName: String
    var productType: String
    var price: Double
    var imageUrl: String?

    init(id: UUID, productName: String, productType: String, price: Double, imageUrl: String?) {
        self.id = id
        self.productName = productName
        self.productType = productType
        self.price = price
        self.imageUrl = imageUrl
    }
}
