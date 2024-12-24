//
//  CustomImageCache.swift
//  Swipe
//
//  Created by Arjun Pratap Choudhary on 23/12/24.
//


import UIKit

class CustomImageCache {
    static let shared = CustomImageCache()
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()
    
    func get(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    func set(forKey key: String, image: UIImage) {
        cache.setObject(image, forKey: key as NSString)
    }
}
