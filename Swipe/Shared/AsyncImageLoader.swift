//
//  AsyncImageLoader.swift
//  Swipe
//
//  Created by Arjun Pratap Choudhary on 23/12/24.
//
import SwiftUI
import Combine

// AsyncImageLoader Class
class AsyncImageLoader: ObservableObject {
    @Published var image: UIImage?
    @Published var isLoading = false
    @Published var error: Error? // Error state

    private var url: URL?
    private var cancellable: AnyCancellable?

    init(url: URL?) {
        self.url = url
        loadImage()
    }

    func loadImage() {
        guard let url = url else { return }
        isLoading = true

        if let cachedImage = CustomImageCache.shared.get(forKey: url.absoluteString) {
            self.image = cachedImage
            self.isLoading = false
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .catch { [weak self] error -> Just<UIImage?> in
                DispatchQueue.main.async {
                    self?.error = error // Store error
                }
                return Just(nil)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] downloadedImage in
                self?.image = downloadedImage
                self?.isLoading = false
                if let downloadedImage = downloadedImage {
                    CustomImageCache.shared.set(forKey: url.absoluteString, image: downloadedImage)
                }
            }
    }

    deinit {
        cancellable?.cancel()
    }
}
