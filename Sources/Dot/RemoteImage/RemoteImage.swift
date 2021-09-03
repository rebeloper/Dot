//
//  RemoteImage.swift
//  Dot
//
//  Created by Alex Nagy on 03.09.2021.
//

import SwiftUI

public struct RemoteImage<Content: View>: View {
    let url: URL?
    let scale: CGFloat
    let transaction: Transaction
    @ViewBuilder let content: (RemoteImagePhase) -> Content
    
    @State private var phase: RemoteImagePhase = .empty
    
    public init(url: URL?, scale: CGFloat = 1) where Content == Image {
        self.init(url: url, scale: scale) { phase in
            phase.image ?? Image(systemName: "gearshape")
        }
    }
    
    public init<I, P>(url: URL?,
               scale: CGFloat = 1,
               @ViewBuilder content: @escaping (Image) -> I,
               @ViewBuilder placeholder: @escaping () -> P)
    where Content == _ConditionalContent<I, P>, I : View, P : View {
        self.init(url: url, scale: scale) { phase in
            if let image = phase.image {
                content(image)
            } else {
                placeholder()
            }
        }
    }
    
    public init(url: URL?,
         scale: CGFloat = 1,
         transaction: Transaction = Transaction(),
         @ViewBuilder content: @escaping (RemoteImagePhase) -> Content) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    public var body: some View {
        content(phase)
            .onAppear(perform: load)
    }
    
    private func load() {
        guard phase.isEmpty,
              let url = url
        else {
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data,
               let uiImage = UIImage(data: data, scale: scale) {
                withTransaction(transaction) {
                    phase = .success(Image(uiImage: uiImage))
                }
            } else if let error = error {
                withTransaction(transaction) {
                    phase = .failure(error)
                }
            }
        }.resume()
    }
}

public enum RemoteImagePhase {
    case empty,
         success(Image),
         failure(Error)
    
    var isEmpty: Bool {
        if case .empty = self {
            return true
        } else {
            return false
        }
    }
    
    var image: Image? {
        if case let .success(image) = self {
            return image
        } else {
            return nil
        }
    }
    
    var error: Error? {
        if case let .failure(error) = self {
            return error
        } else {
            return nil
        }
    }
}
