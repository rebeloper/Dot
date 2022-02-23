//
//  ClippedToTabsViewModifier.swift
//  
//
//  Created by Alex Nagy on 23.02.2022.
//

import SwiftUI

public struct TabsStackClippedViewModifier: ViewModifier {
    
    // MARK: - ObservedObjects
    @ObservedObject public var tabs: Tabs
    
    // MARK: - Bindings
    
    // MARK: - Body
    public func body(content: Content) -> some View {
        TightVStack {
            content
            if tabs.options.isClippedToTabs {
                Space(height: tabs.options.height)
            }
        }
    }
}

public extension View {
    func clippedTo(_ tabs: Tabs) -> some View {
        modifier(TabsStackClippedViewModifier(tabs: tabs))
    }
}
