//
//  ClippedToTabsViewModifier.swift
//  
//
//  Created by Alex Nagy on 23.02.2022.
//

import SwiftUI

public struct TabsStackTopEdgeViewModifier: ViewModifier, KeyboardReadable {
    
    // MARK: - ObservedObjects
    @ObservedObject public var tabs: Tabs
    
    // MARK: - Bindings
    @Binding var ignoresTabsTopEdge: Bool
    
    @State private var isKeyboardVisible = false
    
    // MARK: - Body
    public func body(content: Content) -> some View {
        TightVStack {
            content
            if tabs.stack.tags.count != 0, !isKeyboardVisible {
                Space(height: tabs.visible ? (ignoresTabsTopEdge ? 0 : tabs.options.height) + tabs.options.edgeInsets.bottom : 0)
                    .transition(.scale)
            }
        }
        .onReceive(keyboardPublisher) { isKeyboardVisible in
            withAnimation {
                self.isKeyboardVisible = isKeyboardVisible
            }
        }
    }
}

public extension View {
    
    /// Should the view ignore the top edge of the ``Tabs``
    /// - Parameters:
    ///   - value: binded boolean
    ///   - tabs: tabs
    /// - Returns: some view
    func ignoresTabsTopEdge(_ value: Binding<Bool>, tabs: Tabs) -> some View {
        modifier(TabsStackTopEdgeViewModifier(tabs: tabs, ignoresTabsTopEdge: value))
    }
    
    /// Should the view ignore the top edge of the ``Tabs``
    /// - Parameters:
    ///   - value: boolean
    ///   - tabs: tabs
    /// - Returns: some view
    func ignoresTabsTopEdge(_ value: Bool, tabs: Tabs) -> some View {
        modifier(TabsStackTopEdgeViewModifier(tabs: tabs, ignoresTabsTopEdge: .constant(value)))
    }
    
    /// Sticks the view to the top edge of the ``Tabs``
    /// - Parameter tabs: tabs
    /// - Returns: some view
    func sticksToTopEdge(of tabs: Tabs) -> some View {
        modifier(TabsStackTopEdgeViewModifier(tabs: tabs, ignoresTabsTopEdge: .constant(false)))
    }
}
