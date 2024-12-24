//
//  ImageLoader.swift
//  Swipe
//
//  Created by Arjun Pratap Choudhary on 23/12/24.
//
import SwiftUI

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var url: URL?
    
    func load(from url: URL?) {
        guard let url = url else { return }
        self.url = url
        
        if let cachedImage = ImageCache.shared.object(forKey: url as NSURL) {
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    ImageCache.shared.setObject(image, forKey: url as NSURL)
                    self.image = image
                }
            }
        }
    }
}

struct AsyncImage<Placeholder: View>: View {
    @StateObject private var loader = ImageLoader()
    let placeholder: Placeholder
    let url: URL?
    
    init(url: URL?, @ViewBuilder placeholder: () -> Placeholder) {
        self.url = url
        self.placeholder = placeholder()
    }
    
    var body: some View {
        if let image = loader.image {
            Image(uiImage: image)
                .resizable()
        } else {
            placeholder
                .onAppear { loader.load(from: url) }
        }
    }
}

class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
    private init() {}
    
    subscript(_ key: URL) -> UIImage? {
        get { ImageCache.shared.object(forKey: key as NSURL) }
        set {
            if let value = newValue {
                ImageCache.shared.setObject(value, forKey: key as NSURL)
            } else {
                ImageCache.shared.removeObject(forKey: key as NSURL)
            }
        }
    }
}
