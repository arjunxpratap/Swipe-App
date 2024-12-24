//
//  SwipeApp.swift
//  Swipe
//
//  Created by Arjun Pratap Choudhary on 23/12/24.
//

import SwiftUI
import SwiftData

@main
struct SwipeApp: App {
    init() {
        // Ensure navigation title text is always white
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.black // Black background for the navigation bar
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white] // White title text
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white] // White large title text
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
                .modelContainer(for: [FavoritedProduct.self]) // Attach SwiftData container for persistent storage
        }
    }
}
