//
//  View+.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

public extension View {
    
    /// Wraps the View in a NavigationView
    /// - Returns: A view embeded in a NavigationView
    func embedInNavigationView() -> some View {
        NavigationView { self }
    }
    
    /// Wraps the View in a NavigationView with StackNavigationViewStyle
    /// - Returns: A view embeded in a NavigationView
    func embedInStackNavigationView() -> some View {
        NavigationView { self }.navigationViewStyle(StackNavigationViewStyle())
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
    
}
