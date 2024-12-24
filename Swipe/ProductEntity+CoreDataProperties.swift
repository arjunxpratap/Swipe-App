//
//  ProductEntity+CoreDataProperties.swift
//  Swipe
//
//  Created by Arjun Pratap Choudhary on 23/12/24.
//
//

import Foundation
import CoreData


extension ProductEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductEntity> {
        return NSFetchRequest<ProductEntity>(entityName: "ProductEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var taxRate: Double
    @NSManaged public var productType: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var isSynced: Bool

}

extension ProductEntity : Identifiable {

}
