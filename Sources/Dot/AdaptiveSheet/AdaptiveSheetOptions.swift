//
//  AdaptiveSheetOptions.swift
//  File
//
//  Created by Alex Nagy on 16.08.2021.
//

import SwiftUI

public struct AdaptiveSheetOptions {
    let detents : [UISheetPresentationController.Detent]
    let selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    let prefersScrollingExpandsWhenScrolledToEdge: Bool
    let prefersEdgeAttachedInCompactHeight: Bool
    let prefersGrabberVisible: Bool
    let preferredCornerRadius: CGFloat?
    
    public init(detents: [UISheetPresentationController.Detent] = [.medium(), .large()],
                selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
                largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
                prefersScrollingExpandsWhenScrolledToEdge: Bool = false,
                prefersEdgeAttachedInCompactHeight: Bool = true,
                prefersGrabberVisible: Bool = false,
                preferredCornerRadius: CGFloat? = nil) {
        self.detents = detents
        self.selectedDetentIdentifier = selectedDetentIdentifier
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self.prefersGrabberVisible = prefersGrabberVisible
        self.preferredCornerRadius = preferredCornerRadius
    }
}
