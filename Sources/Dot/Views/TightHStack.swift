//
//  TightHStack.swift
//  Dot
//
//  Created by Alex Nagy on 17.08.2021.
//

import SwiftUI

/// An HStack with 0 spacing
public struct TightHStack<Content: View>: View {
    
    private var alignment: VerticalAlignment
    private var spacing: CGFloat
    private var content: Content
    
    public init(alignment: VerticalAlignment = .center, spacing: CGFloat = 0, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
    
    public var body: some View {
        HStack(alignment: alignment, spacing: spacing, content: {
            content
        })
    }
}
