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
    
    @ViewBuilder
    /// Can create a `Push Out View` from a
    /// - Parameters:
    ///   - isPushOutView: should create a `Push Out View` from a `Pull In View`
    ///   - backgroundColor: The color of the area outside of the `Pull In View`
    /// - Returns: a `Push Out View` or a `Pull In View`
    func isPushOutView(_ isPushOutView: Bool = true, backgroundColor: Color = .clear) -> some View {
        if isPushOutView {
            ZStack {
                backgroundColor
                self
            }
        } else {
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
    
    /// Adds an action to perform when this view recognizes a tap gesture. Clips this view to its bounding rectangular frame and defines the content shape for hit testing. Works with ``Spacer``.
    /// - Parameters:
    ///    - count: The number of taps or clicks required to trigger the action
    ///      closure provided in `action`. Defaults to `1`
    ///    - cornerRadius: corner radius. Default is 0
    ///    - style: rounded corner style. Default is .circular
    ///    - action: The action to perform
    func onClippedTapGesture(count: Int = 1, cornerRadius: CGFloat = 0, style: RoundedCornerStyle = .circular, perform action: @escaping () -> Void) -> some View {
        self
            .clippedContent(cornerRadius: cornerRadius, style: style)
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
    
    /// Layers the given views behind this ``TextEditor``.
    func textEditorBackground<V>(@ViewBuilder _ content: () -> V) -> some View where V : View {
        self
            .onAppear {
                UITextView.appearance().backgroundColor = .clear
            }
            .background(content())
    }
    
    #if canImport(UIKit)
    /// Hides the keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    #endif
    
    @ViewBuilder
    /// Positions this view within an invisible frame having the specified alignment.
    /// - Parameter alignment: The alignment of this view inside the resulting frame.
    func align(_ alignment: ViewAlignment) -> some View {
        switch alignment {
        case .leading:
            self.frame(maxWidth: .infinity, alignment: .leading)
        case .trailing:
            self.frame(maxWidth: .infinity, alignment: .trailing)
        case .top:
            self.frame(maxHeight: .infinity, alignment: .top)
        case .bottom:
            self.frame(maxHeight: .infinity, alignment: .bottomLeading)
        }
    }
    
    /// Fixes this view at its ideal size.
    /// - Returns: A view that fixes this view at its ideal size in the
    ///   dimensions specified by `horizontal` and `vertical`.
    func idealSize() -> some View {
        self.fixedSize()
    }
    
    /// Fixes this view at its ideal size in the specified dimensions.
    /// - Parameters:
    ///   - horizontal: A Boolean value that indicates whether to fix the width
    ///     of the view.
    ///   - vertical: A Boolean value that indicates whether to fix the height
    ///     of the view.
    /// - Returns: A view that fixes this view at its ideal size in the
    ///   dimensions specified by `horizontal` and `vertical`.
    func idealSize(horizontal: Bool, vertical: Bool) -> some View {
        self.fixedSize(horizontal: horizontal, vertical: vertical)
    }
    
    /// Fixes this view at its ideal size in the specified axis.
    /// - Parameter axis: The axis to fix the view size on.
    /// - Returns: A view that fixes this view at its ideal size in the
    ///   dimensions specified by the `axis`.
    func idealSize(axis: SizeAxis) -> some View {
        switch axis {
        case .vertical:
            self.fixedSize(horizontal: false, vertical: true)
        case .horizontal:
            self.fixedSize(horizontal: true, vertical: false)
        }
    }
}

