//
//  AsyncCachedImage.swift
//  
//
//  Created by Alex Nagy on 30.09.2021.
//

import SwiftUI

public struct AsyncCachedImage<Content>: View where Content: View {

    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    public init(url: URL,
         scale: CGFloat = 1.0,
         transaction: Transaction = Transaction(),
         @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    public var body: some View {
        if let cached = AsyncImageCache[url] {
            let _ = print("AsyncCachedImage: cached \(url.absoluteString)")
            content(.success(cached))
        } else {
            let _ = print("AsyncCachedImage: request \(url.absoluteString)")
            AsyncImage(url: url,
                       scale: scale,
                       transaction: transaction) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }

    private func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            AsyncImageCache[url] = image
        }
        return content(phase)
    }
}

