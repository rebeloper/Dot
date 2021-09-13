//
//  View+.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

public extension View {
    
    /// Wraps the View in a NavigationView
    /// - Parameter style: the navigation style
    /// - Returns: A view embeded in a NavigationView with optional style
    @ViewBuilder
    func navigatable(style: NavigatableStyle = .stack) -> some View {
        switch style {
        case .none:
            NavigationView { self }
        case .stack:
            NavigationView { self }.navigationViewStyle(.stack)
        case .automatic:
            NavigationView { self }.navigationViewStyle(.automatic)
        case .columns:
            NavigationView { self }.navigationViewStyle(.columns)
        }
    }
    
    /// Wraps the View in AnyView
    /// - Returns: AnyView
    func anyView() -> AnyView {
        AnyView(self)
    }
    
    /// Positions this view within an invisible frame with the specified size with a set .center alignment.
    /// - Parameters:
    ///   - width: A fixed width for the resulting view. If `width` is `nil`,
    ///     the resulting view assumes this view's sizing behavior.
    ///   - height: A fixed height for the resulting view. If `height` is `nil`,
    ///     the resulting view assumes this view's sizing behavior.
    ///
    /// - Returns: A view with fixed dimensions of `width` and `height`, for the
    ///   parameters that are non-`nil`.
    func frame(width: CGFloat, height: CGFloat) -> some View {
        self.frame(width: width, height: height, alignment: .center)
    }
    
    /// Positions this view within an invisible frame with the specified size with a set .center alignment.
    /// - Parameter square: A fixed width and height for the resulting view. If `width` is `nil`, the resulting view assumes this view's sizing behavior.
    /// - Returns: A square view with fixed dimensions of `width` and `height`.
    func frame(square: CGFloat) -> some View {
        self.frame(width: square, height: square, alignment: .center)
    }
    
    /// Hides / unhides a view
    /// - Parameter shouldHide: hidden value
    /// - Returns: a view that is hidden or not
    @ViewBuilder func isHidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
    
    /// A view that pads this view inside the specified edge insets with a
    /// system-calculated amount of padding.
    /// - Parameters:
    ///   - horizontal: The amount to inset this view on the horizontal edges.
    ///   - vertical: The amount to inset this view on the vertical edges.
    /// - Returns: A view that pads this view using the specified edge insets
    ///   with specified amount of padding.
    func padding(horizontal: CGFloat, vertical: CGFloat) -> some View {
        self.padding(.horizontal, horizontal).padding(.vertical, vertical)
    }
    
    /// Creates a `Push Out View` from a `Pull In View`
    /// - Parameter backgroundColor: The color of the area outside of the `Pull In View`
    /// - Returns: a `Push Out View`
    func asPushOutView(_ backgroundColor: Color = .clear) -> some View {
        ZStack {
            backgroundColor
            self
        }
    }
    
    /// Widens the tappable area of the view. Use it for system images that rarely register taps.
    /// - Parameter square: the side of the square area
    /// - Returns: a view that is better tappable
    func makeBetterTappable(square: CGFloat = 44) -> some View {
        ZStack {
            Color.clear.frame(square: square)
            self
        }
    }
    
    /// Widens the tappable area of the view. Use it for system images that rarely register taps.
    /// - Parameters:
    ///   - width: the width of the widened area
    ///   - height: the height of the widened area
    /// - Returns: a view that is better tappable
    func makeBetterTappable(width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            Color.clear.frame(width: width, height: height)
            self
        }
    }
    
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder
    func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }
    
    /// Configures the title display mode to `.inline` for this view and also configures the view's title for purposes of navigation, using a string.
    /// - Parameter title: The string to display.
    func navigationInlineTitle(_ title: String) -> some View {
        self.navigationBarTitleDisplayMode(.inline)
            .navigationTitle(title)
    }
    
    /// Adds an action to perform when this view recognizes a tap gesture. Works with ``Spacer``.
    ///
    /// Use this method to perform a specific `action` when the user clicks or
    /// taps on the view or container `count` times.
    ///
    /// > Note: If you are creating a control that's functionally equivalent
    /// to a ``Button``, use ``ButtonStyle`` to create a customized button
    /// instead.
    ///
    /// In the example below, the color of the heart images changes to a random
    /// color from the `colors` array whenever the user clicks or taps on the
    /// view twice:
    ///
    ///     struct TapGestureExample: View {
    ///         let colors: [Color] = [.gray, .red, .orange, .yellow,
    ///                                .green, .blue, .purple, .pink]
    ///         @State private var fgColor: Color = .gray
    ///
    ///         var body: some View {
    ///             Image(systemName: "heart.fill")
    ///                 .resizable()
    ///                 .frame(width: 200, height: 200)
    ///                 .foregroundColor(fgColor)
    ///                 .onTapGesture(count: 2, perform: {
    ///                     fgColor = colors.randomElement()!
    ///                 })
    ///         }
    ///     }
    ///
    /// ![A screenshot of a view of a heart.](SwiftUI-View-TapGesture.png)
    ///
    /// - Parameters:
    ///    - count: The number of taps or clicks required to trigger the action
    ///      closure provided in `action`. Defaults to `1`.
    ///    - action: The action to perform.
    func onTapGestureForced(count: Int = 1, perform action: @escaping () -> Void) -> some View {
        self
            .contentShape(Rectangle())
            .onTapGesture(count:count, perform:action)
    }
    
    /// Clips this view to its bounding rectangular frame and defines the content shape for hit testing.
    /// - Parameters:
    ///   - cornerRadius: corner radius. Default is 0
    ///   - style: rounded corner style. Default is .circular
    func clippedContent(cornerRadius: CGFloat = 0, style: RoundedCornerStyle = .circular) -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: style))
            .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: style))
    }
    
    /// Creates a lazy vertical stack view with the given spacing,
    /// vertical alignment, pinning behavior, and content.
    ///
    /// - Parameters:
    ///     - alignment: The guide for aligning the subviews in this stack. All
    ///     child views have the same horizontal screen coordinate.
    ///     - spacing: The distance between adjacent subviews, or `nil` if you
    ///       want the stack to choose a default distance for each pair of
    ///       subviews.
    ///     - pinnedViews: The kinds of child views that will be pinned.
    func vertical(alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = .init()) -> some View {
        LazyVStack(alignment: alignment, spacing: spacing, pinnedViews: pinnedViews) {
            self
        }
    }
    
    /// Creates a lazy horizontal stack view with the given spacing,
    /// vertical alignment, pinning behavior, and content.
    ///
    /// - Parameters:
    ///     - alignment: The guide for aligning the subviews in this stack. All
    ///       child views have the same vertical screen coordinate.
    ///     - spacing: The distance between adjacent subviews, or `nil` if you
    ///       want the stack to choose a default distance for each pair of
    ///       subviews.
    ///     - pinnedViews: The kinds of child views that will be pinned.
    func horizontal(alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = .init()) -> some View {
        LazyHStack(alignment: alignment, spacing: spacing, pinnedViews: pinnedViews) {
            self
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
    func verticalGrid(_ columns: [GridItem] = gridItems_1, alignment: HorizontalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = .init()) -> some View {
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
    func horizontalGrid(_ rows: [GridItem] = gridItems_1, alignment: VerticalAlignment = .center, spacing: CGFloat? = nil, pinnedViews: PinnedScrollableViews = .init()) -> some View {
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
                 pinnedViews: PinnedScrollableViews = .init(),
                 onRefreshTreshold: CGFloat = 60,
                 onRefresh: OnRefresh? = nil,
                 onOffsetChange: ((CGFloat) -> ())? = nil) -> some View {
        ScrollableGrid(scrolls: axis, gridItems: gridItems, showsIndicators: showsIndicators, verticalAlignment: verticalAlignment, horizontalAlignment: horizontalAlignment, spacing: spacing, pinnedViews: pinnedViews, onRefreshTreshold: onRefreshTreshold, onRefresh: onRefresh, onOffsetChange: onOffsetChange) {
            self
        }
    }
}
