//
//  ScrollingGrid+View.swift
//  
//
//  Created by Alex Nagy on 22.12.2021.
//

import SwiftUI

public extension View {
    
    /// Creates a lazy grid that grows vertically, given the provided properties.
    ///
    /// - Parameters:
    ///   - columns: An array of grid items to size and position each row of
    ///    the grid.
    ///   - alignment: The alignment of the grid within its parent view.
    ///   - spacing: The spacing between the grid and the next item in its
    ///   parent view.
    ///   - pinnedViews: Views to pin to the bounds of a parent scroll view.
    ///   - header: The header of the scrollable grid.
    ///   - footer: The footer of the scrollable grid.
    func verticalGridWithHeaderAndFooter<Header: View, Footer: View>(
        _ columns: [GridItem] = gridItems_1,
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil,
        pinnedViews: PinnedScrollableViews = .init(),
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder footer: @escaping () -> Footer) -> some View {
            LazyVGrid(columns: columns, alignment: alignment, spacing: spacing, pinnedViews: pinnedViews) {
                Section {
                    self
                } header: {
                    header()
                } footer: {
                    footer()
                }
            }
        }
    
    /// Creates a lazy grid that grows horizontally, given the provided properties.
    ///
    /// - Parameters:
    ///   - rows: An array of grid items to size and position each column of
    ///    the grid.
    ///   - alignment: The alignment of the grid within its parent view.
    ///   - spacing: The spacing between the grid and the next item in its
    ///   parent view.
    ///   - pinnedViews: Views to pin to the bounds of a parent scroll view.
    ///   - header: The header of the scrollable grid.
    ///   - footer: The footer of the scrollable grid.
    func horizontalGridWithHeaderAndFooter<Header: View, Footer: View>(
        _ rows: [GridItem] = gridItems_1,
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        pinnedViews: PinnedScrollableViews = .init(),
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder footer: @escaping () -> Footer) -> some View {
            LazyHGrid(rows: rows, alignment: alignment, spacing: spacing, pinnedViews: pinnedViews) {
                Section {
                    self
                } header: {
                    header()
                } footer: {
                    footer()
                }
            }
        }
    
    /// Creates a lazy grid that grows vertically, given the provided properties.
    ///
    /// - Parameters:
    ///   - columns: An array of grid items to size and position each row of
    ///    the grid.
    ///   - alignment: The alignment of the grid within its parent view.
    ///   - spacing: The spacing between the grid and the next item in its
    ///   parent view.
    ///   - pinnedViews: Views to pin to the bounds of a parent scroll view.
    ///   - header: The header of the scrollable grid.
    func verticalGridWithHeader<Header: View>(
        _ columns: [GridItem] = gridItems_1,
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil,
        pinnedViews: PinnedScrollableViews = .init(),
        @ViewBuilder header: @escaping () -> Header) -> some View {
            LazyVGrid(columns: columns, alignment: alignment, spacing: spacing, pinnedViews: pinnedViews) {
                Section {
                    self
                } header: {
                    header()
                }
            }
        }
    
    /// Creates a lazy grid that grows horizontally, given the provided properties.
    ///
    /// - Parameters:
    ///   - rows: An array of grid items to size and position each column of
    ///    the grid.
    ///   - alignment: The alignment of the grid within its parent view.
    ///   - spacing: The spacing between the grid and the next item in its
    ///   parent view.
    ///   - pinnedViews: Views to pin to the bounds of a parent scroll view.
    ///   - header: The header of the scrollable grid.
    func horizontalGridWithHeader<Header: View>(
        _ rows: [GridItem] = gridItems_1,
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        pinnedViews: PinnedScrollableViews = .init(),
        @ViewBuilder header: @escaping () -> Header) -> some View {
            LazyHGrid(rows: rows, alignment: alignment, spacing: spacing, pinnedViews: pinnedViews) {
                Section {
                    self
                } header: {
                    header()
                }
            }
        }
    
    /// Creates a lazy grid that grows vertically, given the provided properties.
    ///
    /// - Parameters:
    ///   - columns: An array of grid items to size and position each row of
    ///    the grid.
    ///   - alignment: The alignment of the grid within its parent view.
    ///   - spacing: The spacing between the grid and the next item in its
    ///   parent view.
    ///   - pinnedViews: Views to pin to the bounds of a parent scroll view.
    ///   - footer: The footer of the scrollable grid.
    func verticalGridWithFooter<Footer: View>(
        _ columns: [GridItem] = gridItems_1,
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil,
        pinnedViews: PinnedScrollableViews = .init(),
        @ViewBuilder footer: @escaping () -> Footer) -> some View {
            LazyVGrid(columns: columns, alignment: alignment, spacing: spacing, pinnedViews: pinnedViews) {
                Section {
                    self
                } footer: {
                    footer()
                }
            }
        }
    
    /// Creates a lazy grid that grows horizontally, given the provided properties.
    ///
    /// - Parameters:
    ///   - rows: An array of grid items to size and position each column of
    ///    the grid.
    ///   - alignment: The alignment of the grid within its parent view.
    ///   - spacing: The spacing between the grid and the next item in its
    ///   parent view.
    ///   - pinnedViews: Views to pin to the bounds of a parent scroll view.
    ///   - footer: The footer of the scrollable grid.
    func horizontalGridWithFooter<Footer: View>(
        _ rows: [GridItem] = gridItems_1,
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        pinnedViews: PinnedScrollableViews = .init(),
        @ViewBuilder footer: @escaping () -> Footer) -> some View {
            LazyHGrid(rows: rows, alignment: alignment, spacing: spacing, pinnedViews: pinnedViews) {
                Section {
                    self
                } footer: {
                    footer()
                }
            }
        }
    
    /// Creates a lazy grid that grows vertically, given the provided properties.
    ///
    /// - Parameters:
    ///   - columns: An array of grid items to size and position each row of
    ///    the grid.
    ///   - alignment: The alignment of the grid within its parent view.
    ///   - spacing: The spacing between the grid and the next item in its
    ///   parent view.
    ///   - pinnedViews: Views to pin to the bounds of a parent scroll view.
    func verticalGrid(
        _ columns: [GridItem] = gridItems_1,
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil,
        pinnedViews: PinnedScrollableViews = .init()) -> some View {
            LazyVGrid(columns: columns, alignment: alignment, spacing: spacing, pinnedViews: pinnedViews) {
                self
            }
        }
    
    /// Creates a lazy grid that grows horizontally, given the provided properties.
    ///
    /// - Parameters:
    ///   - rows: An array of grid items to size and position each column of
    ///    the grid.
    ///   - alignment: The alignment of the grid within its parent view.
    ///   - spacing: The spacing between the grid and the next item in its
    ///   parent view.
    ///   - pinnedViews: Views to pin to the bounds of a parent scroll view.
    func horizontalGrid(
        _ rows: [GridItem] = gridItems_1,
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        pinnedViews: PinnedScrollableViews = .init()) -> some View {
            LazyHGrid(rows: rows, alignment: alignment, spacing: spacing, pinnedViews: pinnedViews) {
                self
            }
        }
    
    /// Creates a new instance that's scrollable.
    ///
    /// - Parameters:
    ///   - scrolls: The scroll view's scrollable axis. The default axis is the
    ///     vertical axis.
    ///   - gridItems: An array of grid items.
    ///   - options: Options.
    ///   - pinnedViews: The kinds of child views that will be pinned.
    ///   - onRefresh: The action to take when the scroll view is pulled. Finish the refresh by calling the ``RefreshComplete``
    ///   - onOffsetChange: Optional callback returning the scroll view offset.
    ///   - header: The header of the scrollable grid.
    ///   - footer: The footer of the scrollable grid.
    func scrolls<Header: View, Footer: View>(
        _ axis: ScrollAxis,
        gridItems: [GridItem] = gridItems_1,
        options: ScrollingGridOptions = ScrollingGridOptions(),
        pinnedViews: PinnedScrollableViews = .init(),
        onRefresh: OnRefresh? = nil,
        onOffsetChange: ((CGFloat) -> ())? = nil,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder footer: @escaping () -> Footer) -> some View {
            ScrollingGrid(scrolls: axis, gridItems: gridItems, options: options, pinnedViews: pinnedViews, onRefresh: onRefresh, onOffsetChange: onOffsetChange) {
                self
        } header: {
            header()
        } footer: {
            footer()
        }
    }
    
    /// Creates a new instance that's scrollable.
    ///
    /// - Parameters:
    ///   - scrolls: The scroll view's scrollable axis. The default axis is the
    ///     vertical axis.
    ///   - gridItems: An array of grid items.
    ///   - options: Options.
    ///   - pinnedViews: The kinds of child views that will be pinned.
    ///   - onRefresh: The action to take when the scroll view is pulled. Finish the refresh by calling the ``RefreshComplete``
    ///   - onOffsetChange: Optional callback returning the scroll view offset.
    func scrolls(_ axis: ScrollAxis,
                 gridItems: [GridItem] = gridItems_1,
                 options: ScrollingGridOptions = ScrollingGridOptions(),
                 pinnedViews: PinnedScrollableViews = .init(),
                 onRefresh: OnRefresh? = nil,
                 onOffsetChange: ((CGFloat) -> ())? = nil) -> some View {
        ScrollingGrid(scrolls: axis, gridItems: gridItems, options: options, pinnedViews: pinnedViews, onRefresh: onRefresh, onOffsetChange: onOffsetChange) {
            self
        }
    }
    
    /// Creates a new instance that's scrollable.
    ///
    /// - Parameters:
    ///   - scrolls: The scroll view's scrollable axis. The default axis is the
    ///     vertical axis.
    ///   - gridItems: An array of grid items.
    ///   - options: Options.
    ///   - pinnedViews: The kinds of child views that will be pinned.
    ///   - onRefresh: The action to take when the scroll view is pulled. Finish the refresh by calling the ``RefreshComplete``
    ///   - onOffsetChange: Optional callback returning the scroll view offset.
    ///   - header: The header of the scrollable grid.
    func scrolls<Header: View>(
        _ axis: ScrollAxis,
        gridItems: [GridItem] = gridItems_1,
        options: ScrollingGridOptions = ScrollingGridOptions(),
        pinnedViews: PinnedScrollableViews = .init(),
        onRefresh: OnRefresh? = nil,
        onOffsetChange: ((CGFloat) -> ())? = nil,
        @ViewBuilder header: @escaping () -> Header) -> some View {
        ScrollingGrid(scrolls: axis, gridItems: gridItems, options: options, pinnedViews: pinnedViews, onRefresh: onRefresh, onOffsetChange: onOffsetChange) {
            self
        } header: {
            header()
        }
    }
    
    /// Creates a new instance that's scrollable.
    ///
    /// - Parameters:
    ///   - scrolls: The scroll view's scrollable axis. The default axis is the
    ///     vertical axis.
    ///   - gridItems: An array of grid items.
    ///   - options: Options.
    ///   - pinnedViews: The kinds of child views that will be pinned.
    ///   - onRefresh: The action to take when the scroll view is pulled. Finish the refresh by calling the ``RefreshComplete``
    ///   - onOffsetChange: Optional callback returning the scroll view offset.
    ///   - footer: The footer of the scrollable grid.
    func scrolls<Footer: View>(
        _ axis: ScrollAxis,
        gridItems: [GridItem] = gridItems_1,
        options: ScrollingGridOptions = ScrollingGridOptions(),
        pinnedViews: PinnedScrollableViews = .init(),
        onRefresh: OnRefresh? = nil,
        onOffsetChange: ((CGFloat) -> ())? = nil,
        @ViewBuilder footer: @escaping () -> Footer) -> some View {
        ScrollingGrid(scrolls: axis, gridItems: gridItems, options: options, pinnedViews: pinnedViews, onRefresh: onRefresh, onOffsetChange: onOffsetChange) {
            self
        } footer: {
            footer()
        }
    }
}
