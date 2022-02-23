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
            if !isKeyboardVisible {
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
    func ignoresTabsTopEdge(_ value: Binding<Bool>, tabs: Tabs) -> some View {
        modifier(TabsStackTopEdgeViewModifier(tabs: tabs, ignoresTabsTopEdge: value))
    }
    
    func ignoresTabsTopEdge(_ value: Bool, tabs: Tabs) -> some View {
        modifier(TabsStackTopEdgeViewModifier(tabs: tabs, ignoresTabsTopEdge: .constant(value)))
    }
}
