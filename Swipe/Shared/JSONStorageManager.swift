//
//  JSONStorageManager.swift
//  Swipe
//
//  Created by Arjun Pratap Choudhary on 23/12/24.
//

import Foundation

class JSONStorageManager {
    static let shared = JSONStorageManager()
    private init() {}

    private let favoritesFileName = "favorites.json"

    private var favoritesFileURL: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(favoritesFileName)
    }

    // MARK: - Favorites
    func saveFavorites(_ products: [Product]) {
        do {
            let data = try JSONEncoder().encode(products)
            try data.write(to: favoritesFileURL, options: [.atomic, .completeFileProtection])
            print("Favorites saved successfully to \(favoritesFileURL)")
        } catch {
            print("Failed to save favorites: \(error.localizedDescription)")
        }
    }

    func loadFavorites() -> [Product] {
        do {
            let data = try Data(contentsOf: favoritesFileURL)
            let products = try JSONDecoder().decode([Product].self, from: data)
            print("Favorites loaded successfully from \(favoritesFileURL)")
            return products
        } catch {
            print("Failed to load favorites: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - Generic Save/Load
    func saveAny<T: Encodable>(_ object: T, fileName: String) {
        let url = getFileURL(fileName: fileName)
        do {
            let data = try JSONEncoder().encode(object)
            try data.write(to: url, options: [.atomic, .completeFileProtection])
        } catch {
            print("Error saving to \(fileName): \(error.localizedDescription)")
        }
    }
    
    func loadAny<T: Decodable>(_ type: T.Type, fileName: String) -> T? {
        let url = getFileURL(fileName: fileName)
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(type, from: data)
        } catch {
            print("Error loading \(fileName): \(error.localizedDescription)")
            return nil
        }
    }
    
    func removeFile(named fileName: String) {
        let url = getFileURL(fileName: fileName)
        try? FileManager.default.removeItem(at: url)
    }
    
    private func getFileURL(fileName: String) -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent(fileName)
    }
}
