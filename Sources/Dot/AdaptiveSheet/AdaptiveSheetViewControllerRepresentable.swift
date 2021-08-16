//
//  AdaptiveSheetViewControllerRepresentable.swift
//  Dot
//
//  Created by Alex Nagy on 16.08.2021.
//

import SwiftUI

public struct AdaptiveSheetViewControllerRepresentable<Content: View>: UIViewControllerRepresentable {
    
    @Binding var isPresented: Bool
    let adaptiveSheetOptions: AdaptiveSheetOptions
    let content: Content
    
    public init(isPresented: Binding<Bool>,
                adaptiveSheetOptions: AdaptiveSheetOptions,
                @ViewBuilder content: @escaping () -> Content) {
        self._isPresented = isPresented
        self.adaptiveSheetOptions = adaptiveSheetOptions
        self.content = content()
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIViewController(context: Context) -> AdaptiveSheetViewController<Content> {
        let vc = AdaptiveSheetViewController(coordinator: context.coordinator,
                                             adaptiveSheetOptions : adaptiveSheetOptions,
                                             content: {content})
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: AdaptiveSheetViewController<Content>, context: Context) {
        if isPresented {
            uiViewController.presentModalView()
        } else {
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
