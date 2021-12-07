//
//  NavigationOptions.swift
//  
//
//  Created by Alex Nagy on 16.11.2021.
//

import Foundation
import SwiftUI

/// A struct representing the options for how to present a view.
public struct NavigationOptions {
    
    public let style: NavigationStyle
    public var onDismiss: (() -> Void)?
    
    public init(
        style: NavigationStyle,
        onDismiss: (() -> Void)?
    ) {
        self.style = style
        self.onDismiss = onDismiss
    }
    
    public init(style: NavigationStyle) {
        self.style = style
        self.onDismiss = nil
    }
}

/// Represents a style for how a view should be presented.
public enum NavigationStyle: Equatable {

    case regular(isDetailLink: Bool = false)
    case sheet
    case fullScreenCover

    public static let `default`: NavigationStyle = .regular(isDetailLink: false)
}

