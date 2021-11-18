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
    public let options: NavigationOptions
    
    public init(screen: Screen, options: NavigationOptions) {
        self.screen = screen
        self.options = options
    }
    
    public init(screen: Screen) {
        self.screen = screen
        self.options = .init(style: .default)
    }
}
