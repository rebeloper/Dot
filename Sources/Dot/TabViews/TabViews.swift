//
//  TabViews.swift
//  Dot
//
//  Created by Alex Nagy on 17.08.2021.
//

import SwiftUI

public class TabViews: ObservableObject {
    
    /// TabView selection
    @Published public var selection: Int = 0
    
    /// Creates a TabView mananger
    /// - Parameter initialSelection: the initial TabView selection
    public init(initialSelection: Int) {
        self.selection = initialSelection
    }
}

public extension View {
    /// Adds a TabView mananger to the view
    /// - Parameter tabViews: TabViews
    /// - Returns: a view with a TabViewMananger
    func uses(_ tabViews: TabViews) -> some View {
        self.environmentObject(tabViews)
    }
}
