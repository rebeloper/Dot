//
//  NavigationPresentationOptions.swift
//  
//
//  Created by Alex Nagy on 16.11.2021.
//

import Foundation

/// A struct representing the options for how to present a view.
public struct NavigationPresentationOptions {
    
    public let style: NavigationPresentationStyle
    public var onDismiss: (() -> Void)?
    
    public init(style: NavigationPresentationStyle, onDismiss: (() -> Void)? = nil) {
        self.style = style
        self.onDismiss = onDismiss
    }
}

/// Represents a style for how a view should be presented.
public enum NavigationPresentationStyle {

    case _pushNotAvailable // alias for push
    case sheet
    case fullScreenCover
    case navigationSheet
    case navigationFullScreenCover

    public static let `default`: NavigationPresentationStyle = .sheet
}

