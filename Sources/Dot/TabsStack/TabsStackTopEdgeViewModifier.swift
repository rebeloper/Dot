//
//  ClippedToTabsViewModifier.swift
//  
//
//  Created by Alex Nagy on 23.02.2022.
//

import SwiftUI

public struct TabsStackTopEdgeViewModifier: ViewModifier {
    
    // MARK: - ObservedObjects
    @ObservedObject public var tabs: Tabs
    
    // MARK: - Bindings
    @Binding var ignoresTabsTopEdge: Bool
    
    // MARK: - Body
    public func body(content: Content) -> some View {
        TightVStack {
            content
            Space(height: tabs.visible ? (ignoresTabsTopEdge ? 0 : tabs.options.height) + tabs.options.edgeInsets.bottom : 0)
                .transition(.scale)
        }
    }
}

public extension View {
    func ignoresTabsTopEdge(_ value: Binding<Bool>, tabs: Tabs) -> some View {
        modifier(TabsStackTopEdgeViewModifier(tabs: tabs, ignoresTabsTopEdge: value))
    }
}
