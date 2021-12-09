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
    public let navigatable: Bool
    public var onDismiss: (() -> Void)?
    
    public init(
        style: NavigationStyle,
        navigatable: Bool = true,
        onDismiss: (() -> Void)? = nil
    ) {
        self.style = style
        self.navigatable = navigatable
        self.onDismiss = onDismiss
    }
    
}

