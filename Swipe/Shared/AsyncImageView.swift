//
//  AsyncImageView.swift
//  Swipe
//
//  Created by Arjun Pratap Choudhary on 23/12/24.
//


import SwiftUI

// AsyncImageView Struct
struct AsyncImageView: View {
    @StateObject private var loader: AsyncImageLoader
    let placeholder: Image

    init(url: URL?, placeholder: Image = Image("default_placeholder")) {
        _loader = StateObject(wrappedValue: AsyncImageLoader(url: url))
        self.placeholder = placeholder
    }

    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if loader.isLoading {
                ProgressView()
                    .frame(width: 60, height: 60)  // Placeholder size
            } else if loader.error != nil {
                placeholder
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)  // Error placeholder size
            } else {
                placeholder
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)  // Placeholder size
            }
        }
        .clipped()
        .onAppear {
            loader.loadImage()
        }
    }
}
