//
//  AdaptiveSheetViewControllerRepresentable.swift
//  Dot
//
//  Created by Alex Nagy on 16.08.2021.
//

import SwiftUI

public struct AdaptiveSheetViewControllerRepresentable<Content: View>: UIViewControllerRepresentable {
    
    let content: Content
    @Binding var isPresented: Bool
    let detents : [UISheetPresentationController.Detent]
    let selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    let prefersScrollingExpandsWhenScrolledToEdge: Bool
    let prefersEdgeAttachedInCompactHeight: Bool
    let prefersGrabberVisible: Bool
    let preferredCornerRadius: CGFloat?
    
    public init(isPresented: Binding<Bool>,
                detents : [UISheetPresentationController.Detent] = [.medium(), .large()],
                selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
                largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
                prefersScrollingExpandsWhenScrolledToEdge: Bool = false,
                prefersEdgeAttachedInCompactHeight: Bool = true,
                prefersGrabberVisible: Bool = false,
                preferredCornerRadius: CGFloat? = nil,
                @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.detents = detents
        self.selectedDetentIdentifier = selectedDetentIdentifier
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        self.prefersGrabberVisible = prefersGrabberVisible
        self.preferredCornerRadius = preferredCornerRadius
        self._isPresented = isPresented
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIViewController(context: Context) -> AdaptiveSheetViewController<Content> {
        let vc = AdaptiveSheetViewController(coordinator: context.coordinator,
                                             detents : detents,
                                             selectedDetentIdentifier: selectedDetentIdentifier,
                                             largestUndimmedDetentIdentifier: largestUndimmedDetentIdentifier,
                                             prefersScrollingExpandsWhenScrolledToEdge:  prefersScrollingExpandsWhenScrolledToEdge,
                                             prefersEdgeAttachedInCompactHeight: prefersEdgeAttachedInCompactHeight,
                                             prefersGrabberVisible: prefersGrabberVisible,
                                             preferredCornerRadius: preferredCornerRadius,
                                             content: {content})
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: AdaptiveSheetViewController<Content>, context: Context) {
        if isPresented{
            uiViewController.presentModalView()
        }else{
            uiViewController.dismissModalView()
        }
    }
    
    public class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        var parent: AdaptiveSheetViewControllerRepresentable
        init(_ parent: AdaptiveSheetViewControllerRepresentable) {
            self.parent = parent
        }
        //Adjust the variable when the user dismisses with a swipe
        public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            if parent.isPresented{
                parent.isPresented = false
            }
            
        }
        
    }
}
