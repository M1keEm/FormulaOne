//
//  AsyncImageLoader.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 30/05/2025.
//


import SwiftUI

struct AsyncImageLoader: View {
    let url: URL?
    let placeholder: Image
    @StateObject private var loader: ImageLoader
    
    init(url: URL?, placeholder: Image = Image(systemName: "photo")) {
        self.url = url
        self.placeholder = placeholder
        _loader = StateObject(wrappedValue: ImageLoader(url: url, cache: ImageCache.shared))
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                placeholder
            }
        }
        .onAppear(perform: loader.load)
        .onDisappear(perform: loader.cancel)
    }
}

final class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let url: URL?
    private var currentTask: URLSessionDataTask?
    private let cache: ImageCache
    
    init(url: URL?, cache: ImageCache) {
        self.url = url
        self.cache = cache
    }
    
    func load() {
        guard let url = url else { return }
        
        if let cachedImage = cache.get(forKey: url) {
            self.image = cachedImage
            return
        }
        
        currentTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self else { return }
            
            if let data = data, let image = UIImage(data: data) {
                self.cache.set(image, forKey: url)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
        currentTask?.resume()
    }
    
    func cancel() {
        currentTask?.cancel()
    }
}
