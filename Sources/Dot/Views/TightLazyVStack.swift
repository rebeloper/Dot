//
//  TightLazyVStack.swift
//  Dot
//
//  Created by Alex Nagy on 17.08.2021.
//

import SwiftUI

/// A VStack with 0 spacing
public struct TightLazyVStack<Content: View>: View {
    
    private var alignment: HorizontalAlignment
    private var spacing: CGFloat
    private var content: Content
    
    public init(alignment: HorizontalAlignment = .center, spacing: CGFloat = 0, @ViewBuilder content: () -> Content) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }
    
    public var body: some View {
        LazyVStack(alignment: alignment, spacing: spacing, content: {
            content
        })
    }
}

