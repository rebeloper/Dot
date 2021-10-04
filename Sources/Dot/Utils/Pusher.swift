//
//  Pusher.swift
//  
//
//  Created by Alex Nagy on 04.10.2021.
//

import SwiftUI

/// Tappable ``Spacer`` alternative. A flexible space that expands along the major axis of its containing stack layout, or on both axes if not contained in a stack.
///
/// A pusher creates an adaptive view with a clear color content that expands as much as it can.
public struct Pusher: View {
    
    public let minWidth: CGFloat?
    public let minHeight: CGFloat?
    
    /// Tappable ``Spacer`` alternative. A flexible space that expands along the major axis of its containing stack layout, or on both axes if not contained in a stack.
    ///
    /// A pusher creates an adaptive view with a clear color content that expands as much as it can.
    /// - Parameters:
    ///   - minWidth: The minimum width this pusher can be shrunk to, along the axis of expansion. If `nil`, the system default spacing between views is used.
    ///   - minHeight: The minimum height this pusher can be shrunk to, along the axis of expansion. If `nil`, the system default spacing between views is used.
    public init(minWidth: CGFloat? = nil,
                minHeight: CGFloat? = nil) {
        self.minWidth = minWidth
        self.minHeight = minHeight
    }
    
    public var body: some View {
        Color.clear
            .frame(minWidth: minWidth, minHeight: minHeight)
            .clippedContent()
    }
}
