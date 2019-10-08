//
//  ImageCacher.swift
//  ImgurViewer
//
//  Created by sargis on 10/7/19.
//  Copyright © 2019 sargis. All rights reserved.
//

import UIKit

class ImageCacher {
    private let imageCache = NSCache<NSString, UIImage>()
    static let shared = ImageCacher()
    private init() {
    }
    
    func cacheObject() -> NSCache<NSString, UIImage> {
        return self.imageCache
    }
}
