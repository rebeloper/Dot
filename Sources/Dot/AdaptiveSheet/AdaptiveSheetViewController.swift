//
//  AdaptiveSheetViewController.swift
//  Dot
//
//  Created by Alex Nagy on 16.08.2021.
//

import SwiftUI

public class AdaptiveSheetViewController<Content: View>: UIViewController {
    
    let content: Content
    let coordinator: AdaptiveSheetViewControllerRepresentable<Content>.Coordinator
    let detents : [UISheetPresentationController.Detent]
    let selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    let largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier?
    let prefersScrollingExpandsWhenScrolledToEdge: Bool
    let prefersEdgeAttachedInCompactHeight: Bool
    let prefersGrabberVisible: Bool
    let preferredCornerRadius: CGFloat?
    
    private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    public init(coordinator: AdaptiveSheetViewControllerRepresentable<Content>.Coordinator,
                detents : [UISheetPresentationController.Detent] = [.medium(), .large()],
                selectedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = nil,
                largestUndimmedDetentIdentifier: UISheetPresentationController.Detent.Identifier? = .medium,
                prefersScrollingExpandsWhenScrolledToEdge: Bool = false,
                prefersEdgeAttachedInCompactHeight: Bool = true,
                prefersGrabberVisible: Bool = false,
                preferredCornerRadius: CGFloat? = nil,
                @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.coordinator = coordinator
        self.detents = detents
        self.selectedDetentIdentifier = selectedDetentIdentifier
        self.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
        self.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
        self.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
        self.prefersGrabberVisible = prefersGrabberVisible
        self.preferredCornerRadius = preferredCornerRadius
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func dismissModalView(){
        dismiss(animated: true, completion: nil)
    }
    func presentModalView(){
        
        let hostingController = UIHostingController(rootView: content)
        
        hostingController.modalPresentationStyle = .popover
        hostingController.presentationController?.delegate = coordinator as UIAdaptivePresentationControllerDelegate
        hostingController.modalTransitionStyle = .coverVertical
        if let hostPopover = hostingController.popoverPresentationController {
            hostPopover.sourceView = super.view
            let sheet = hostPopover.adaptiveSheetPresentationController
            //As of 13 Beta 4 if .medium() is the only detent in landscape error occurs
            sheet.detents = (isLandscape ? [.large()] : detents)
            sheet.selectedDetentIdentifier = (isLandscape ? .large : selectedDetentIdentifier)
            sheet.largestUndimmedDetentIdentifier = largestUndimmedDetentIdentifier
            sheet.prefersScrollingExpandsWhenScrolledToEdge = prefersScrollingExpandsWhenScrolledToEdge
            sheet.prefersEdgeAttachedInCompactHeight = prefersEdgeAttachedInCompactHeight
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = prefersGrabberVisible
            sheet.preferredCornerRadius = preferredCornerRadius
        }
        if presentedViewController == nil{
            present(hostingController, animated: true, completion: nil)
        }
    }
    /// To compensate for orientation as of 13 Beta 4 only [.large()] works for landscape
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            isLandscape = true
            self.presentedViewController?.popoverPresentationController?.adaptiveSheetPresentationController.detents = [.large()]
        } else {
            isLandscape = false
            self.presentedViewController?.popoverPresentationController?.adaptiveSheetPresentationController.detents = detents
        }
    }
}

