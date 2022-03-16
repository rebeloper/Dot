//
//  Text+.swift
//  
//
//  Created by Alex Nagy on 03.10.2021.
//

import SwiftUI

public extension Text {
    
    /// A view that displays one or more, attributed or not string lines of read-only text.
    init(attributed anyString: String) {
        do {
            let attributedString = try AttributedString(markdown: anyString)
            self.init(attributedString)
        } catch {
            self.init(anyString)
        }
    }
}
