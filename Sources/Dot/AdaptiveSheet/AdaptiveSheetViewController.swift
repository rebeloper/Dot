//
//  AdaptiveSheetViewController.swift
//  Dot
//
//  Created by Alex Nagy on 16.08.2021.
//

import SwiftUI

public class AdaptiveSheetViewController<Content: View>: UIViewController {
    
    let coordinator: AdaptiveSheetViewControllerRepresentable<Content>.Coordinator
    let adaptiveSheetOptions: AdaptiveSheetOptions
    let content: Content
    
    private var isLandscape: Bool = UIDevice.current.orientation.isLandscape
    public init(coordinator: AdaptiveSheetViewControllerRepresentable<Content>.Coordinator,
                adaptiveSheetOptions: AdaptiveSheetOptions = AdaptiveSheetOptions(),
                @ViewBuilder content: @escaping () -> Content) {
        self.coordinator = coordinator
        self.adaptiveSheetOptions = adaptiveSheetOptions
        self.content = content()
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func dismissModalView() {
        dismiss(animated: true, completion: nil)
    }
    func presentModalView() {
        
        let hostingController = UIHostingController(rootView: content)
        
        hostingController.modalPresentationStyle = .popover
        hostingController.presentationController?.delegate = coordinator as UIAdaptivePresentationControllerDelegate
        hostingController.modalTransitionStyle = .coverVertical
        if let hostPopover = hostingController.popoverPresentationController {
            hostPopover.sourceView = super.view
            let sheet = hostPopover.adaptiveSheetPresentationController
            //As of 13 Beta 4 if .medium() is the only detent in landscape error occurs
            sheet.detents = (isLandscape ? [.large()] : adaptiveSheetOptions.detents)
            sheet.selectedDetentIdentifier = (isLandscape ? .large : adaptiveSheetOptions.selectedDetentIdentifier)
            sheet.largestUndimmedDetentIdentifier = adaptiveSheetOptions.largestUndimmedDetentIdentifier
            sheet.prefersScrollingExpandsWhenScrolledToEdge = adaptiveSheetOptions.prefersScrollingExpandsWhenScrolledToEdge
            sheet.prefersEdgeAttachedInCompactHeight = adaptiveSheetOptions.prefersEdgeAttachedInCompactHeight
            sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
            sheet.prefersGrabberVisible = adaptiveSheetOptions.prefersGrabberVisible
            sheet.preferredCornerRadius = adaptiveSheetOptions.preferredCornerRadius
        }
        if presentedViewController == nil {
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
            self.presentedViewController?.popoverPresentationController?.adaptiveSheetPresentationController.detents = adaptiveSheetOptions.detents
        }
    }
}

