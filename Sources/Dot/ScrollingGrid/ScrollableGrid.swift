//
//  ScrollableGrid.swift
//  
//
//  Created by Alex Nagy on 22.12.2021.
//

import SwiftUI

/// ``ForEach`` inside ``Group`` with ``scrollableItem``s. ``data`` must be an array of ``Identifiable``s. Use with ``.scrolls(...)``
public struct ScrollableGrid<I: Identifiable, C: View>: View {
    
    private let data: [I]
    private let content: (I) -> (C)
    
    public init(_ data: [I], @ViewBuilder _ content: @escaping (I) -> (C)) {
        self.data = data
        self.content = content
    }
    
    public var body: some View {
        Group {
            ForEach(data) { identifiable in
                content(identifiable)
            }
        }
    }
}
