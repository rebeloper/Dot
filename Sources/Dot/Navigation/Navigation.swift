//
//  Navigation.swift
//  Dot
//
//  Created by Alex Nagy on 09.08.2021.
//

import SwiftUI

public class Navigation: ObservableObject {
    
    public init() {}
    
    @Published public var isPushed = false
    @Published public var isPresented = false
    @Published public var isCovered = false
    @Published public var isAdaptiveSheetPresented = false
    @Published public var adaptiveSheetOptions: AdaptiveSheetOptions?
    @Published public var destination: AnyView?
    @Published public var onDismiss: (() -> Void)?
    
    public func present<Destination: View>(_ type: NavigationType, adaptiveSheetOptions: AdaptiveSheetOptions? = nil, @ViewBuilder destination: () -> (Destination), onDismiss: (() -> Void)? = nil) {
        self.destination = AnyView(destination())
        switch type {
        case .page:
            self.onDismiss = onDismiss
            isPushed = true
            self.adaptiveSheetOptions = nil
        case .sheet:
            self.onDismiss = onDismiss
            isPresented = true
            self.adaptiveSheetOptions = nil
        case .fullScreenCover:
            self.onDismiss = onDismiss
            isCovered = true
            self.adaptiveSheetOptions = nil
        case .adaptiveSheet:
            self.onDismiss = onDismiss
            isAdaptiveSheetPresented = true
            self.adaptiveSheetOptions = adaptiveSheetOptions
        }
    }
    
}

public struct AdaptiveSheetOptions {
    let detents : [UISheetPresentationController.Detent]
    let selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    let prefersScrollingExpandsWhenScrolledToEdge: Bool
    let prefersEdgeAttachedInCompactHeight: Bool
    let prefersGrabberVisible: Bool
    let preferredCornerRadius: CGFloat?
}
