//
//  ImageCache.swift
//  FormulaOne
//
//  Created by Michał Banaszek on 30/05/2025.
//

import UIKit
import SwiftUI

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, UIImage>()
    
    private init() {}
    
    func get(forKey key: URL) -> UIImage? {
        return cache.object(forKey: key as NSURL)
    }
    
    func set(_ image: UIImage, forKey key: URL) {
        cache.setObject(image, forKey: key as NSURL)
    }
}
