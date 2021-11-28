//
//  SlideInView.swift
//  
//
//  Created by Alex Nagy on 28.11.2021.
//

import SwiftUI

public struct SlideInView<Content: View, Container: View>: View {
    
    @Binding private var isActive: Bool
    private var edge: Edge
    private var paddingPercentage: CGFloat
    private var options: SlideInViewOptions
    private var content: () -> Content
    private var container: () -> Container
    
    /// Slide in view
    ///
    /// Create a manager:
    /// ```
    /// class SlideInViewManager: ObservableObject {
    ///     @Published var isActive: Bool = false
    /// }
    /// ```
    /// Initialize it:
    /// ```
    /// @StateObject private var slideInViewManager = SlideInViewManager()
    /// ```
    /// Use it:
    /// ```
    /// SlideInView(isActive: $slideInViewManager.isActive) {
    ///     MenuView()
    ///         .edgesIgnoringSafeArea(.bottom)
    /// } container: {
    ///     NavigationView {
    ///         HomeView()
    ///     }
    ///     .navigationViewStyle(.stack)
    /// }
    /// .environmentObject(slideInViewManager)
    /// ```
    /// Access the `state` of the slide in view (`active` or `inactive`) or toggle the `state` from the `SlideInViewMananger` Envirinment Object
    /// ```
    /// @EnvironmentObject var slideInViewManager: SlideInViewManager
    /// ```
    /// - Parameters:
    ///   - isActive: binding to show/hide the slide in view
    ///   - edge: the slide in edge; default is `leading`
    ///   - paddingPercentage: the percentage of the slide in view's padding; default is `0.35`
    ///   - options: options; default is `SlideInViewOptions` defaults
    ///   - content: the slide in view content
    ///   - container: the container the slide in view will be presented on top of
    public init(isActive: Binding<Bool>,
                edge: Edge = .leading,
                paddingPercentage: CGFloat = 0.35,
                options: SlideInViewOptions = SlideInViewOptions(),
                content: @escaping () -> Content,
                container: @escaping () -> Container) {
        self._isActive = isActive
        self.edge = edge
        self.paddingPercentage = paddingPercentage
        self.options = options
        self.content = content
        self.container = container
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                container()
                
                ZStack {
                    if isActive {
                        options.paddingColor
                            .opacity(options.paddingColorOpacity)
                            .ignoresSafeArea()
                            .onTapGesture {
                                if options.shouldDismissUponExternalTap {
                                    isActive.toggle()
                                }
                            }
                        content()
                            .padding(getPaddingEdgeSet(), getPadding(for: proxy))
                            .transition(
                                .asymmetric(
                                    insertion: .move(edge: edge),
                                    removal: .move(edge: edge)
                                )
                            )
                            .gesture(DragGesture(minimumDistance: 20, coordinateSpace: .global)
                                        .onEnded { value in
                                if options.shouldDismissUponSwipe {
                                    let horizontalAmount = value.translation.width as CGFloat
                                    let verticalAmount = value.translation.height as CGFloat
                                    
                                    if abs(horizontalAmount) > abs(verticalAmount) {
                                        if horizontalAmount < 0 {
                                            if edge == .leading {
                                                isActive.toggle()
                                            }
                                        } else if edge == .trailing {
                                            isActive.toggle()
                                        }
                                    } else {
                                        if verticalAmount < 0 {
                                            if edge == .top {
                                                isActive.toggle()
                                            }
                                        } else if edge == .bottom {
                                            isActive.toggle()
                                        }
                                    }
                                }
                                
                            })
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .animation(.default, value: isActive)
            }
        }
    }
}

public extension SlideInView {
    private func getPaddingEdgeSet() -> Edge.Set {
        switch edge {
        case .top:
            return .bottom
        case .leading:
            return .trailing
        case .bottom:
            return .top
        case .trailing:
            return .leading
        }
    }
    
    private func getPadding(for proxy: GeometryProxy) -> CGFloat {
        switch edge {
        case .top, .bottom:
            return proxy.size.height * paddingPercentage
        case .leading, .trailing:
            return proxy.size.width * paddingPercentage
        }
    }
}

public struct SlideInViewOptions {
    public var paddingColor: Color
    public var paddingColorOpacity: CGFloat
    public var shouldDismissUponSwipe: Bool
    public var shouldDismissUponExternalTap: Bool
    
    public init(paddingColor: Color = Color(.label),
         paddingColorOpacity: CGFloat = 0.1,
         shouldDismissUponSwipe: Bool = true,
         shouldDismissUponExternalTap: Bool = true) {
        self.paddingColor = paddingColor
        self.paddingColorOpacity = paddingColorOpacity
        self.shouldDismissUponSwipe = shouldDismissUponSwipe
        self.shouldDismissUponExternalTap = shouldDismissUponExternalTap
    }
}

public extension View {
    
    /// Adds a slide in view onto the container view
    ///
    /// Create a manager:
    /// ```
    /// class SlideInViewManager: ObservableObject {
    ///     @Published var isActive: Bool = false
    /// }
    /// ```
    /// Initialize it:
    /// ```
    /// @StateObject private var slideInViewManager = SlideInViewManager()
    /// ```
    /// Use it:
    /// ```
    /// NavigationView {
    ///     HomeView()
    /// }
    /// .navigationViewStyle(.stack)
    /// .slideInView(isActive: $slideInViewManager.isActive) {
    ///     MenuView()
    ///         .edgesIgnoringSafeArea(.bottom)
    /// }
    /// .environmentObject(slideInViewManager)
    /// ```
    /// Access the `state` of the slide in view (`active` or `inactive`) or toggle the `state` from the `SlideInViewMananger` Envirinment Object
    /// ```
    /// @EnvironmentObject var slideInViewManager: SlideInViewManager
    /// ```
    /// - Parameters:
    ///   - isActive: binding to show/hide the slide in view
    ///   - edge: the slide in edge; default is `leading`
    ///   - paddingPercentage: the percentage of the slide in view's padding; default is `0.35`
    ///   - options: options; default is `SlideInViewOptions` defaults
    ///   - content: the slide in view content
    ///   - container: the container the slide in view will be presented on top of
    /// - Returns: A view that has a slide in view
    func slideInView<Content: View>(isActive: Binding<Bool>, edge: Edge = .leading, paddingPercentage: CGFloat = 0.3, options: SlideInViewOptions = SlideInViewOptions(), content: @escaping () -> Content) -> some View {
        SlideInView(isActive: isActive, edge: edge, paddingPercentage: paddingPercentage, options: options, content: content) {
            self
        }
    }
}
