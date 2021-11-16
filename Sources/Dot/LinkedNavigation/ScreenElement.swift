//
//  ScreenElement.swift
//  
//
//  Created by Alex Nagy on 16.11.2021.
//

import Foundation

/// Convenience struct for containing a Screen and its options
public struct ScreenElement<Screen> {
    public let screen: Screen
    public let options: NavigationPresentationOptions
    
    public init(screen: Screen, options: NavigationPresentationOptions) {
        self.screen = screen
        self.options = options
    }
}
