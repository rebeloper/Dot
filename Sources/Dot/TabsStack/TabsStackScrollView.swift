//
//  TabsStackScrollView.swift
//  
//
//  Created by Alex Nagy on 09.12.2021.
//

import SwiftUI

public struct TabsStackScrollView<Content: View>: View {
    
    @EnvironmentObject private var tabs: Tabs
    
    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let content: () -> Content
    
    /// Convenience ScrollView to be used inside TabsStack pages.
    /// - Parameters:
    ///   - axes: The scroll view's scrollable axis. The default axis is the
    ///     vertical axis.
    ///   - showsIndicators: A Boolean value that indicates whether the scroll
    ///     view displays the scrollable component of the content offset, in a way
    ///     suitable for the platform. The default value for this parameter is
    ///     `false`.
    ///   - content: The view builder that creates the scrollable view.
    public init(_ axes: Axis.Set = .vertical,
                showsIndicators: Bool = false,
                @ViewBuilder content: @escaping () -> Content) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.content = content
    }
    
    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            VStack(spacing: 0) {
                content()
                Spacer().frame(height: tabs.visible ? tabs.options.height + tabs.options.edgeInsets.bottom : 0)
            }
        }
    }
}

