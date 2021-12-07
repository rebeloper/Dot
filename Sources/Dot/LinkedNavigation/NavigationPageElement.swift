//
//  NavigationPageElement.swift
//  
//
//  Created by Alex Nagy on 16.11.2021.
//

import Foundation

/// Convenience struct for containing a Page and its options
public struct NavigationPageElement<Page> {
    public let page: Page
    public let options: NavigationOptions
    
    public init(
        page: Page,
        options: NavigationOptions
    ) {
        self.page = page
        self.options = options
    }
    
    public init(page: Page) {
        self.page = page
        self.options = .init(style: .default)
    }
}

