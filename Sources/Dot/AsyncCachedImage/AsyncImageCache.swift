//
//  AsyncImageCache.swift
//  
//
//  Created by Alex Nagy on 30.09.2021.
//

import SwiftUI

public class AsyncImageCache {
    static private var cache: [URL: Image] = [:]

    static public subscript(url: URL) -> Image? {
        get {
            AsyncImageCache.cache[url]
        }
        set {
            AsyncImageCache.cache[url] = newValue
        }
    }
}
