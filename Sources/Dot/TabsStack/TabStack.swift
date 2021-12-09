//
//  TabStack.swift
//  
//
//  Created by Alex Nagy on 09.12.2021.
//

import Foundation

/// A thin wrapper around an `Int` array.
public struct TabStack {
    
    /// The underlying array of tabs.
    public internal(set) var tabs: [Int]
    
    /// Initializes the stack with an empty array of tabs.
    public init() {
        self.tabs = []
    }
    
    /// Initializes the stack with an array of tabs from a count.
    public init(count: Int) {
        var tabs = [Int]()
        for i in 0..<count {
            tabs.append(i)
        }
        self.tabs = tabs
    }
    
    /// Initializes the stack with an array of tabs.
    public init(tabs: [Int]) {
        self.tabs = tabs
    }
    
}

