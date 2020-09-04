//
//  EnvironmentValues+ImageCache.swift
//  Youtube
//
//  Created by Hugo Plante on 2020-09-04.
//  Copyright © 2020 HPS. All rights reserved.
//

import SwiftUI

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
