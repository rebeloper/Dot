//
//  NavigationFlow.swift
//  
//
//  Created by Alex Nagy on 16.11.2021.
//

import Foundation

/// A thin wrapper around a `PageElements` array.
public struct NavigationFlow<Page> {
    
    /// The underlying array of page elements.
    public internal(set) var pageElements: [NavigationPageElement<Page>]
    
    /// The duration of a push/present of a view in milliseconds
    public internal(set) var pushPresentMilliseconds: Int = 650
    
    /// The duration of a pop of a view in milliseconds
    public internal(set) var popMilliseconds: Int = 650
    
    /// Initializes the stack with an empty array of screens.
    public init() {
        self.pageElements = []
    }
    
    /// Initializes the stack with a single root page.
    /// - Parameter root: The root page.
    public init(root: Page) {
        self.pageElements = [NavigationPageElement(page: root, options: .init(style: .default))]
    }
    
}

