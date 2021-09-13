//
//  ScrollableGrid.swift
//  Dot
//
//  Created by Alex Nagy on 13.09.2021.
//

import SwiftUI

public struct ScrollableGrid<Content: View>: View {
    private var axis: Axis.Set
    private var gridItems: [GridItem]
    private var showsIndicators: Bool
    private var verticalAlignment: VerticalAlignment
    private var horizontalAlignment: HorizontalAlignment
    private var spacing: CGFloat?
    private var pinnedViews: PinnedScrollableViews
    private var onRefreshTreshold: CGFloat
    private var onRefresh: OnRefresh? // the refreshing action
    private var onOffsetChange: ((CGFloat) -> Void)?
    private var content: () -> Content
    
    @State private var state = RefreshState.waiting // the current state
    
    private var refreshViewLenght: CGFloat = 30
    
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
    ///   - pinnedViews: The kinds of child views that will be pinned.
    ///   - onRefreshTreshold: the offset treshhold for ``onRefresh``
    ///   - onRefresh: The action to take when the scroll view is pulled. Finish the refresh by calling the ``RefreshComplete``
    ///   - onOffsetChange: Optional callback returning the scroll view offset.
    ///   - content: The content of the scrollable grid.
    public init(scrolls: ScrollAxis = .vertically,
                gridItems: [GridItem] = gridItems_1,
                showsIndicators: Bool = true,
                verticalAlignment: VerticalAlignment = .center,
                horizontalAlignment: HorizontalAlignment = .center,
                spacing: CGFloat? = 0,
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
        self.pinnedViews = pinnedViews
        self.onRefreshTreshold = onRefreshTreshold
        self.onRefresh = onRefresh
        self.onOffsetChange = onOffsetChange
        self.content = content
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
                        VStack {
                            scrollViewOffsetReader(axes: .vertical)
                            content()
                                .verticalGrid(gridItems, alignment: horizontalAlignment, spacing: spacing, pinnedViews: pinnedViews)
                        }
                        .offset(y: (state == .loading) ? refreshViewLenght : 0)
                    } else {
                        HStack {
                            scrollViewOffsetReader(axes: .horizontal)
                            content()
                                .horizontalGrid(gridItems, alignment: verticalAlignment, spacing: spacing, pinnedViews: pinnedViews)
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
