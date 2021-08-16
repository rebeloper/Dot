//
//  AdaptiveSheetViewModifier.swift
//  Dot
//
//  Created by Alex Nagy on 16.08.2021.
//

import SwiftUI

public struct AdaptiveSheetViewModifier<T: View>: ViewModifier {
    
    let sheetContent: T
    @Binding var isPresented: Bool
    let detents : [UISheetPresentationController.Detent]
    let selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    let prefersScrollingExpandsWhenScrolledToEdge: Bool
    let prefersEdgeAttachedInCompactHeight: Bool
    let prefersGrabberVisible: Bool
    let preferredCornerRadius: CGFloat?
    
    public init(isPresented: Binding<Bool>,
                detents: [UISheetPresentationController.Detent] = [.medium(), .large()],
                selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
                largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
                prefersScrollingExpandsWhenScrolledToEdge: Bool = false,
                prefersEdgeAttachedInCompactHeight: Bool = true,
                prefersGrabberVisible: Bool = false,
                preferredCornerRadius: CGFloat? = nil,
                @ViewBuilder content: @escaping () -> T) {
        self.sheetContent = content()
        self.detents = detents
        self.selectedDetentIdentifier = selectedDetentIdentifier
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        self.prefersGrabberVisible = prefersGrabberVisible
        self.preferredCornerRadius = preferredCornerRadius
        self._isPresented = isPresented
    }
    
    public func body(content: Content) -> some View {
        ZStack{
            content
            AdaptiveSheetViewControllerRepresentable(isPresented: $isPresented,
                                                     detents: detents,
                                                     selectedDetentIdentifier: selectedDetentIdentifier,
                                                     largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier,
                                                     prefersScrollingExpandsWhenScrolledToEdge: prefersScrollingExpandsWhenScrolledToEdge,
                                                     prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
                                                     prefersGrabberVisible: prefersGrabberVisible,
                                                     preferredCornerRadius: preferredCornerRadius,
                                                     content: {sheetContent}).frame(width: 0, height: 0)
        }
    }
}

public extension View {
    func adaptiveSheet<T: View>(isPresented: Binding<Bool>,
                                detents : [UISheetPresentationController.Detent] = [.medium(), .large()],
                                selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
                                largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
                                prefersScrollingExpandsWhenScrolledToEdge: Bool = false,
                                prefersEdgeAttachedInCompactHeight: Bool = true,
                                prefersGrabberVisible: Bool = false,
                                preferredCornerRadius: CGFloat? = nil,
                                @ViewBuilder content: @escaping () -> T)-> some View {
        modifier(AdaptiveSheetViewModifier(isPresented: isPresented,
                               detents : detents,
                               selectedDetentIdentifier: selectedDetentIdentifier,
                               largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier,
                               prefersScrollingExpandsWhenScrolledToEdge: prefersScrollingExpandsWhenScrolledToEdge,
                               prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
                               prefersGrabberVisible: prefersGrabberVisible,
                               preferredCornerRadius: preferredCornerRadius,
                               content: content))
    }
}

