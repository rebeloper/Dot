//
//  ScrollableGrid.swift
//  Dot
//
//  Created by Alex Nagy on 13.09.2021.
//

import SwiftUI

public struct ScrollableGrid<Content: View, Header: View, Footer: View>: View {
    private var axis: Axis.Set
    private var gridItems: [GridItem]
    private var showsIndicators: Bool
    private var verticalAlignment: VerticalAlignment
    private var horizontalAlignment: HorizontalAlignment
    private var spacing: CGFloat?
    private var startPadding: CGFloat
    private var endPadding: CGFloat
    private var pinnedViews: PinnedScrollableViews
    private var onRefreshTreshold: CGFloat
    private var onRefresh: OnRefresh? // the refreshing action
    private var onOffsetChange: ((CGFloat) -> Void)?
    private var content: () -> Content
    private var header: (() -> Header)?
    private var footer: (() -> Footer)?
    
    @State private var state = RefreshState.waiting // the current state
    
    private var refreshViewLenght: CGFloat = 30
    
    @State private var size: CGSize = .zero
    
    /// Creates a new instance that's scrollable.
    ///
    /// - Parameters:
    ///   - scrolls: The scroll view's scrollable axis. The default axis is the
    ///     vertical axis.
    ///   - gridItems: An array of grid items.
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
    ///   - pinnedViews: The kinds of child views that will be pinned.
    ///   - onRefreshTreshold: the offset treshhold for ``onRefresh``
    ///   - onRefresh: The action to take when the scroll view is pulled. Finish the refresh by calling the ``RefreshComplete``
    ///   - onOffsetChange: Optional callback returning the scroll view offset.
    ///   - content: The content of the scrollable grid.
    ///   - header: The header of the scrollable grid.
    ///   - footer: The footer of the scrollable grid.
    public init(scrolls: ScrollAxis = .vertically,
                gridItems: [GridItem] = gridItems_1,
                showsIndicators: Bool = true,
                verticalAlignment: VerticalAlignment = .center,
                horizontalAlignment: HorizontalAlignment = .center,
                spacing: CGFloat? = 0,
                startPadding: CGFloat = 0,
                endPadding: CGFloat = 0,
                pinnedViews: PinnedScrollableViews = .init(),
                onRefreshTreshold: CGFloat = 60,
                onRefresh: OnRefresh? = nil,
                onOffsetChange: ((CGFloat) -> Void)? = nil,
                @ViewBuilder content: @escaping () -> Content,
                @ViewBuilder header: @escaping () -> Header,
                @ViewBuilder footer: @escaping () -> Footer) {
        self.gridItems = gridItems
        self.axis = scrolls == .vertically ? .vertical : .horizontal
        self.showsIndicators = showsIndicators
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        self.spacing = spacing
        self.startPadding = startPadding
        self.endPadding = endPadding
        self.pinnedViews = pinnedViews
        self.onRefreshTreshold = onRefreshTreshold
        self.onRefresh = onRefresh
        self.onOffsetChange = onOffsetChange
        self.content = content
        self.header = header
        self.footer = footer
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: axis == .vertical ? .top : .leading) {
                // The moving positioning indicator, that sits at the top
                // of the ScrollView and scrolls down with the content
                PositionIndicator(type: .moving)
                    .frame(height: 0)
                
                // Your ScrollView content. If we're loading, we want
                // to keep it below the loading view, hence the alignmentGuide.
                
                ScrollView(axis, showsIndicators: showsIndicators) {
                    if axis == .vertical {
                        VStack(spacing: 0) {
                            scrollViewOffsetReader(axes: .vertical)
                            Spacer().frame(width: 0, height: startPadding)
                            content()
                                .if(header != nil && footer != nil, transform: { content in
                                    content.verticalGridWithHeaderAndFooter(gridItems, alignment: horizontalAlignment, spacing: spacing, pinnedViews: pinnedViews) {
                                        header!()
                                    } footer: {
                                        footer!()
                                    }
                                })
                                    .if(header == nil && footer == nil, transform: { content in
                                        content.verticalGrid(gridItems, alignment: horizontalAlignment, spacing: spacing, pinnedViews: pinnedViews)
                                    })
                                    .if(header != nil && footer == nil, transform: { content in
                                        content.verticalGridWithHeader(gridItems, alignment: horizontalAlignment, spacing: spacing, pinnedViews: pinnedViews, header: {
                                            header!()
                                        })
                                    })
                                    .if(header == nil && footer != nil, transform: { content in
                                        content.verticalGridWithFooter(gridItems, alignment: horizontalAlignment, spacing: spacing, pinnedViews: pinnedViews, footer: {
                                            footer!()
                                        })
                                    })
                                    Spacer().frame(width: 0, height: endPadding)
                        }
                        .offset(y: (state == .loading) ? refreshViewLenght : 0)
                    } else {
                        HStack(spacing: 0) {
                            scrollViewOffsetReader(axes: .horizontal)
                            Spacer().frame(width: startPadding, height: 0)
                            content()
                                .if(header != nil && footer != nil, transform: { content in
                                    content.horizontalGridWithHeaderAndFooter(gridItems, alignment: verticalAlignment, spacing: spacing, pinnedViews: pinnedViews) {
                                        header!()
                                    } footer: {
                                        footer!()
                                    }
                                })
                                    .if(header == nil && footer == nil, transform: { content in
                                        content.horizontalGrid(gridItems, alignment: verticalAlignment, spacing: spacing, pinnedViews: pinnedViews)
                                    })
                                    .if(header != nil && footer == nil, transform: { content in
                                        content.horizontalGridWithHeader(gridItems, alignment: verticalAlignment, spacing: spacing, pinnedViews: pinnedViews, header: {
                                            header!()
                                        })
                                    })
                                    .if(header == nil && footer != nil, transform: { content in
                                        content.horizontalGridWithFooter(gridItems, alignment: verticalAlignment, spacing: spacing, pinnedViews: pinnedViews, footer: {
                                            footer!()
                                        })
                                    })
                                    Spacer().frame(width: endPadding, height: 0)
                        }
                        .offset(x: (state == .loading) ? refreshViewLenght : 0)
                    }
                }
                
                // The loading view. It's offset to the top of the content unless we're loading.
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: axis == .vertical ? 0 : refreshViewLenght, height: axis == .vertical ? refreshViewLenght : 0)
                    if state == .loading {
                        ProgressView()
                    }
                }
                .offset(x: axis == .vertical ? 0 : (state == .loading) ? 0 : -refreshViewLenght, y: axis == .vertical ? (state == .loading) ? 0 : -refreshViewLenght : 0)
            }
            .coordinateSpace(name: "scrollViewOffsetReaderCoordinateSpaceName")
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self, perform: { offset in
                onOffsetChange?(offset)
                
                if onRefresh == nil { return }
                // If the user pulled down below the threshold, prime the view
                if offset > onRefreshTreshold && state == .waiting {
                    state = .primed
                    
                    // If the view is primed and we've crossed the threshold again on the
                    // way back, trigger the refresh
                } else if offset < onRefreshTreshold && state == .primed {
                    withAnimation {
                        state = .loading
                    }
                    onRefresh? { // trigger the refreshing callback
                        // once refreshing is done, smoothly move the loading view
                        // back to the offset position
                        withAnimation {
                            self.state = .waiting
                        }
                    }
                }
            })
        }
        .onPreferenceChange(ViewSizeKey.self) {
            size = CGSize(width: max(size.width, $0.width), height: max(size.height, $0.height))
        }
        .if(axis == .vertical, transform: { view in
            view.frame(width: size.width)
        })
            .if(axis == .horizontal, transform: { view in
                view.frame(height: size.height)
            })
    }
    
    public func scrollViewOffsetReader(axes: Axis.Set) -> some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: ScrollViewOffsetPreferenceKey.self,
                    value: axes == .vertical ? proxy.frame(in: .named("scrollViewOffsetReaderCoordinateSpaceName")).minY : proxy.frame(in: .named("scrollViewOffsetReaderCoordinateSpaceName")).minX
                )
        }
        .frame(width: axes == .vertical ? nil : 1, height: axes == .vertical ? 1 : nil)
    }
    
}

private struct ViewSizeKey: PreferenceKey {
    static var defaultValue: CGSize { .zero }
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value == .zero ? CGSize(width: value.width + nextValue().width, height: value.height + nextValue().height) : value
    }
}

// There are two type of positioning views - one that scrolls with the content,
// and one that stays fixed
private enum PositionType {
    case fixed, moving
}

// This struct is the currency of the Preferences, and has a type
// (fixed or moving) and the actual Y-axis value.
// It's Equatable because Swift requires it to be.
private struct Position: Equatable {
    let type: PositionType
    let y: CGFloat
    let x: CGFloat
}

// This might seem weird, but it's necessary due to the funny nature of
// how Preferences work. We can't just store the last position and merge
// it with the next one - instead we have a queue of all the latest positions.
private struct PositionPreferenceKey: PreferenceKey {
    typealias Value = [Position]
    
    static var defaultValue = [Position]()
    
    static func reduce(value: inout [Position], nextValue: () -> [Position]) {
        value.append(contentsOf: nextValue())
    }
}

private struct PositionIndicator: View {
    let type: PositionType
    
    var body: some View {
        GeometryReader { proxy in
            // the View itself is an invisible Shape that fills as much as possible
            Color.clear
            // Compute the top Y position and emit it to the Preferences queue
                .preference(key: PositionPreferenceKey.self, value: [Position(type: type, y: proxy.frame(in: .global).minY, x: proxy.frame(in: .global).minX)])
        }
    }
}

// Tracks the state of the RefreshableScrollViewWithOffset - it's either:
// 1. waiting for a scroll to happen
// 2. has been primed by pulling down beyond THRESHOLD
// 3. is doing the refreshing.
private enum RefreshState {
    case waiting, primed, loading
}

// Callback that'll trigger once refreshing is done
public typealias RefreshComplete = () -> Void
// The actual refresh action that's called once refreshing starts. It has the
// RefreshComplete callback to let the refresh action let the View know
// once it's done refreshing.
public typealias OnRefresh = (@escaping RefreshComplete) -> Void

// predifined grid items arrays
public let gridItems_1 = [GridItem(spacing: 0)]
public let gridItems_2 = [GridItem(spacing: 0), GridItem(spacing: 0)]
public let gridItems_3 = [GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0)]
public let gridItems_4 = [GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0)]
public let gridItems_5 = [GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0), GridItem(spacing: 0)]

// helper preference key
public struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    public static var defaultValue: CGFloat = .zero
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}

public extension ScrollableGrid where Header == EmptyView, Footer == EmptyView {
    /// Creates a new instance that's scrollable.
    ///
    /// - Parameters:
    ///   - scrolls: The scroll view's scrollable axis. The default axis is the
    ///     vertical axis.
    ///   - gridItems: An array of grid items.
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
    ///   - pinnedViews: The kinds of child views that will be pinned.
    ///   - onRefreshTreshold: the offset treshhold for ``onRefresh``
    ///   - onRefresh: The action to take when the scroll view is pulled. Finish the refresh by calling the ``RefreshComplete``
    ///   - onOffsetChange: Optional callback returning the scroll view offset.
    ///   - content: The content of the scrollable grid.
    init(scrolls: ScrollAxis = .vertically,
         gridItems: [GridItem] = gridItems_1,
         showsIndicators: Bool = true,
         verticalAlignment: VerticalAlignment = .center,
         horizontalAlignment: HorizontalAlignment = .center,
         spacing: CGFloat? = 0,
         startPadding: CGFloat = 0,
         endPadding: CGFloat = 0,
         pinnedViews: PinnedScrollableViews = .init(),
         onRefreshTreshold: CGFloat = 60,
         onRefresh: OnRefresh? = nil,
         onOffsetChange: ((CGFloat) -> Void)? = nil,
         @ViewBuilder content: @escaping () -> Content) {
        self.gridItems = gridItems
        self.axis = scrolls == .vertically ? .vertical : .horizontal
        self.showsIndicators = showsIndicators
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        self.spacing = spacing
        self.startPadding = startPadding
        self.endPadding = endPadding
        self.pinnedViews = pinnedViews
        self.onRefreshTreshold = onRefreshTreshold
        self.onRefresh = onRefresh
        self.onOffsetChange = onOffsetChange
        self.content = content
        self.header = nil
        self.footer = nil
    }
}

public extension ScrollableGrid where Footer == EmptyView {
    /// Creates a new instance that's scrollable.
    ///
    /// - Parameters:
    ///   - scrolls: The scroll view's scrollable axis. The default axis is the
    ///     vertical axis.
    ///   - gridItems: An array of grid items.
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
    ///   - pinnedViews: The kinds of child views that will be pinned.
    ///   - onRefreshTreshold: the offset treshhold for ``onRefresh``
    ///   - onRefresh: The action to take when the scroll view is pulled. Finish the refresh by calling the ``RefreshComplete``
    ///   - onOffsetChange: Optional callback returning the scroll view offset.
    ///   - content: The content of the scrollable grid.
    ///   - header: The header of the scrollable grid.
    init(scrolls: ScrollAxis = .vertically,
         gridItems: [GridItem] = gridItems_1,
         showsIndicators: Bool = true,
         verticalAlignment: VerticalAlignment = .center,
         horizontalAlignment: HorizontalAlignment = .center,
         spacing: CGFloat? = 0,
         startPadding: CGFloat = 0,
         endPadding: CGFloat = 0,
         pinnedViews: PinnedScrollableViews = .init(),
         onRefreshTreshold: CGFloat = 60,
         onRefresh: OnRefresh? = nil,
         onOffsetChange: ((CGFloat) -> Void)? = nil,
         @ViewBuilder content: @escaping () -> Content,
         @ViewBuilder header: @escaping () -> Header) {
        self.gridItems = gridItems
        self.axis = scrolls == .vertically ? .vertical : .horizontal
        self.showsIndicators = showsIndicators
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        self.spacing = spacing
        self.startPadding = startPadding
        self.endPadding = endPadding
        self.pinnedViews = pinnedViews
        self.onRefreshTreshold = onRefreshTreshold
        self.onRefresh = onRefresh
        self.onOffsetChange = onOffsetChange
        self.content = content
        self.header = header
        self.footer = nil
    }
}

public extension ScrollableGrid where Header == EmptyView {
    /// Creates a new instance that's scrollable.
    ///
    /// - Parameters:
    ///   - scrolls: The scroll view's scrollable axis. The default axis is the
    ///     vertical axis.
    ///   - gridItems: An array of grid items.
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
    ///   - pinnedViews: The kinds of child views that will be pinned.
    ///   - onRefreshTreshold: the offset treshhold for ``onRefresh``
    ///   - onRefresh: The action to take when the scroll view is pulled. Finish the refresh by calling the ``RefreshComplete``
    ///   - onOffsetChange: Optional callback returning the scroll view offset.
    ///   - content: The content of the scrollable grid.
    ///   - footer: The footer of the scrollable grid.
    init(scrolls: ScrollAxis = .vertically,
         gridItems: [GridItem] = gridItems_1,
         showsIndicators: Bool = true,
         verticalAlignment: VerticalAlignment = .center,
         horizontalAlignment: HorizontalAlignment = .center,
         spacing: CGFloat? = 0,
         startPadding: CGFloat = 0,
         endPadding: CGFloat = 0,
         pinnedViews: PinnedScrollableViews = .init(),
         onRefreshTreshold: CGFloat = 60,
         onRefresh: OnRefresh? = nil,
         onOffsetChange: ((CGFloat) -> Void)? = nil,
         @ViewBuilder content: @escaping () -> Content,
         @ViewBuilder footer: @escaping () -> Footer) {
        self.gridItems = gridItems
        self.axis = scrolls == .vertically ? .vertical : .horizontal
        self.showsIndicators = showsIndicators
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        self.spacing = spacing
        self.startPadding = startPadding
        self.endPadding = endPadding
        self.pinnedViews = pinnedViews
        self.onRefreshTreshold = onRefreshTreshold
        self.onRefresh = onRefresh
        self.onOffsetChange = onOffsetChange
        self.content = content
        self.header = nil
        self.footer = footer
    }
}

public extension View {
    
    func scrollableItem() -> some View {
        self.background(GeometryReader { gp in
            // calculate height by consumed background and store in
            // view preference
            Color.clear
                .preference(key: ViewSizeKey.self,
                            value: gp.frame(in: .local).size)
                .onAppear {
                    print("->> \(gp.frame(in: .local).size)")
                }
        })
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
    ///   - pinnedViews: The kinds of child views that will be pinned.
    ///   - onRefreshTreshold: the offset treshhold for ``onRefresh``
    ///   - onRefresh: The action to take when the scroll view is pulled. Finish the refresh by calling the ``RefreshComplete``
    ///   - onOffsetChange: Optional callback returning the scroll view offset.
    ///   - header: The header of the scrollable grid.
    ///   - footer: The footer of the scrollable grid.
    func scrolls<Header: View, Footer: View>(_ axis: ScrollAxis,
                                             gridItems: [GridItem] = gridItems_1,
                                             showsIndicators: Bool = true,
                                             verticalAlignment: VerticalAlignment = .center,
                                             horizontalAlignment: HorizontalAlignment = .center,
                                             spacing: CGFloat? = 0,
                                             startPadding: CGFloat = 0,
                                             endPadding: CGFloat = 0,
                                             pinnedViews: PinnedScrollableViews = .init(),
                                             onRefreshTreshold: CGFloat = 60,
                                             onRefresh: OnRefresh? = nil,
                                             onOffsetChange: ((CGFloat) -> ())? = nil,
                                             @ViewBuilder header: @escaping () -> Header,
                                             @ViewBuilder footer: @escaping () -> Footer) -> some View {
        ScrollableGrid(scrolls: axis, gridItems: gridItems, showsIndicators: showsIndicators, verticalAlignment: verticalAlignment, horizontalAlignment: horizontalAlignment, spacing: spacing, startPadding: startPadding, endPadding: endPadding, pinnedViews: pinnedViews, onRefreshTreshold: onRefreshTreshold, onRefresh: onRefresh, onOffsetChange: onOffsetChange) {
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
    ///   - pinnedViews: The kinds of child views that will be pinned.
    ///   - onRefreshTreshold: the offset treshhold for ``onRefresh``
    ///   - onRefresh: The action to take when the scroll view is pulled. Finish the refresh by calling the ``RefreshComplete``
    ///   - onOffsetChange: Optional callback returning the scroll view offset.
    func scrolls(_ axis: ScrollAxis,
                 gridItems: [GridItem] = gridItems_1,
                 showsIndicators: Bool = true,
                 verticalAlignment: VerticalAlignment = .center,
                 horizontalAlignment: HorizontalAlignment = .center,
                 spacing: CGFloat? = 0,
                 startPadding: CGFloat = 0,
                 endPadding: CGFloat = 0,
                 pinnedViews: PinnedScrollableViews = .init(),
                 onRefreshTreshold: CGFloat = 60,
                 onRefresh: OnRefresh? = nil,
                 onOffsetChange: ((CGFloat) -> ())? = nil) -> some View {
        ScrollableGrid(scrolls: axis, gridItems: gridItems, showsIndicators: showsIndicators, verticalAlignment: verticalAlignment, horizontalAlignment: horizontalAlignment, spacing: spacing, startPadding: startPadding, endPadding: endPadding, pinnedViews: pinnedViews, onRefreshTreshold: onRefreshTreshold, onRefresh: onRefresh, onOffsetChange: onOffsetChange) {
            self
        }
    }
    
    /// Creates a new instance that's scrollable.
    ///
    /// - Parameters:
    ///   - scrolls: The scroll view's scrollable axis. The default axis is the
    ///     vertical axis.
    ///   - gridItems: An array of grid items.
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
    ///   - pinnedViews: The kinds of child views that will be pinned.
    ///   - onRefreshTreshold: the offset treshhold for ``onRefresh``
    ///   - onRefresh: The action to take when the scroll view is pulled. Finish the refresh by calling the ``RefreshComplete``
    ///   - onOffsetChange: Optional callback returning the scroll view offset.
    ///   - header: The header of the scrollable grid.
    func scrolls<Header: View>(_ axis: ScrollAxis,
                               gridItems: [GridItem] = gridItems_1,
                               showsIndicators: Bool = true,
                               verticalAlignment: VerticalAlignment = .center,
                               horizontalAlignment: HorizontalAlignment = .center,
                               spacing: CGFloat? = 0,
                               startPadding: CGFloat = 0,
                               endPadding: CGFloat = 0,
                               pinnedViews: PinnedScrollableViews = .init(),
                               onRefreshTreshold: CGFloat = 60,
                               onRefresh: OnRefresh? = nil,
                               onOffsetChange: ((CGFloat) -> ())? = nil,
                               @ViewBuilder header: @escaping () -> Header) -> some View {
        ScrollableGrid(scrolls: axis, gridItems: gridItems, showsIndicators: showsIndicators, verticalAlignment: verticalAlignment, horizontalAlignment: horizontalAlignment, spacing: spacing, startPadding: startPadding, endPadding: endPadding, pinnedViews: pinnedViews, onRefreshTreshold: onRefreshTreshold, onRefresh: onRefresh, onOffsetChange: onOffsetChange) {
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
    ///   - pinnedViews: The kinds of child views that will be pinned.
    ///   - onRefreshTreshold: the offset treshhold for ``onRefresh``
    ///   - onRefresh: The action to take when the scroll view is pulled. Finish the refresh by calling the ``RefreshComplete``
    ///   - onOffsetChange: Optional callback returning the scroll view offset.
    ///   - footer: The footer of the scrollable grid.
    func scrolls<Footer: View>(_ axis: ScrollAxis,
                               gridItems: [GridItem] = gridItems_1,
                               showsIndicators: Bool = true,
                               verticalAlignment: VerticalAlignment = .center,
                               horizontalAlignment: HorizontalAlignment = .center,
                               spacing: CGFloat? = 0,
                               startPadding: CGFloat = 0,
                               endPadding: CGFloat = 0,
                               pinnedViews: PinnedScrollableViews = .init(),
                               onRefreshTreshold: CGFloat = 60,
                               onRefresh: OnRefresh? = nil,
                               onOffsetChange: ((CGFloat) -> ())? = nil,
                               @ViewBuilder footer: @escaping () -> Footer) -> some View {
        ScrollableGrid(scrolls: axis, gridItems: gridItems, showsIndicators: showsIndicators, verticalAlignment: verticalAlignment, horizontalAlignment: horizontalAlignment, spacing: spacing, startPadding: startPadding, endPadding: endPadding, pinnedViews: pinnedViews, onRefreshTreshold: onRefreshTreshold, onRefresh: onRefresh, onOffsetChange: onOffsetChange) {
            self
        } footer: {
            footer()
        }
    }
}
