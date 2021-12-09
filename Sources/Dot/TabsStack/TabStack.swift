//
//  TabStack.swift
//  
//
//  Created by Alex Nagy on 09.12.2021.
//

import Foundation

/// A thin wrapper around an `Int` array.
public struct TabStack {
    
    /// The underlying array of tab tags.
    public internal(set) var tags: [Int]
    
    /// Initializes the stack with an empty array of tags.
    public init() {
        self.tags = []
    }
    
    /// Initializes the stack with an array of tags from a count.
    public init(count: Int) {
        var tags = [Int]()
        for i in 0..<count {
            tags.append(i)
        }
        self.tags = tags
    }
    
    /// Initializes the stack with an array of tags.
    public init(tags: [Int]) {
        self.tags = tags
    }
    
}

