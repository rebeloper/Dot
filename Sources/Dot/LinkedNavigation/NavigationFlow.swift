//
//  NavigationFlow.swift
//  
//
//  Created by Alex Nagy on 16.11.2021.
//

import Foundation

/// A thin wrapper around a `ScreenElements` array.
public struct NavigationFlow<Screen> {
    
    /// The underlying array of screen elements.
    public internal(set) var screenElements: [ScreenElement<Screen>]
    
    /// The duration of a push/present of a view in milliseconds
    public internal(set) var pushPresentMilliseconds: Int = 650
    
    /// The duration of a pop of a view in milliseconds
    public internal(set) var popMilliseconds: Int = 650
    
    /// Initializes the stack with an empty array of screens.
    public init() {
        self.screenElements = []
    }
    
    /// Initializes the stack with a single root screen.
    /// - Parameter root: The root screen.
    public init(root: Screen) {
        self.screenElements = [ScreenElement(screen: root, options: .init(style: .default))]
    }
    
}

