//
//  ScrollingGridOptions.swift
//  
//
//  Created by Alex Nagy on 22.12.2021.
//

import SwiftUI

public struct ScrollingGridOptions {
    public var showsIndicators: Bool
    public var verticalAlignment: VerticalAlignment
    public var horizontalAlignment: HorizontalAlignment
    public var spacing: CGFloat?
    public var startPadding: CGFloat
    public var endPadding: CGFloat
    public var onRefreshTreshold: CGFloat
    public var tabs: Tabs
    public var sticksToTopEdgeOfTab: Bool
    
    /// ScrollableGrid options
    /// - Parameters:
    ///   - showsIndicators: A Boolean value that indicates whether the scroll
    ///     view displays the scrollable component of the content offset, in a way
    ///     suitable for the platform. The default value for this parameter is
    ///     `true`.
    ///   - verticalAlignment: The guide for aligning the subviews in this stack. All child views have the same vertical screen coordinate.
    ///   - horizontalAlignment: The guide for aligning the subviews in this stack. All child views have the same horizontal screen coordinate.
    ///   - spacing: The distance between adjacent subviews, or `nil` if you
    ///       want the stack to choose a default distance for each pair of
    ///       subviews.
    ///   - startPadding: The top / leading padding of the scrollable grid.
    ///   - endPadding: The bottom / trailing padding of the scrollabel grid.
    ///   - onRefreshTreshold: the offset treshhold for ``onRefresh``
    ///   - tabs: tabs; default is ``Tabs(count: 0)``
    ///   - sticksToTopEdgeOfTab: declares if the scrolling grid should stick to the top edge of the ``Tabs``
    public init(showsIndicators: Bool = true,
                verticalAlignment: VerticalAlignment = .center,
                horizontalAlignment: HorizontalAlignment = .center,
                spacing: CGFloat? = 0,
                startPadding: CGFloat = 0,
                endPadding: CGFloat = 0,
                onRefreshTreshold: CGFloat = 60,
                tabs: Tabs = Tabs(),
                sticksToTopEdgeOfTab: Bool = true
    ) {
        self.showsIndicators = showsIndicators
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        self.spacing = spacing
        self.startPadding = startPadding
        self.endPadding = endPadding
        self.onRefreshTreshold = onRefreshTreshold
        self.tabs = tabs
        self.sticksToTopEdgeOfTab = sticksToTopEdgeOfTab
    }
}
