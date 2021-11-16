//
//  NavigationStack.swift
//  
//
//  Created by Alex Nagy on 16.11.2021.
//

import Foundation
import SwiftUI

/// NavigationStack maintains a stack of presented views.
public struct NavigationStack<Screen, ScreenView: View>: View {
    
    /// The array of screens that represents the navigation stack.
    @Binding var stack: [ScreenElement<Screen>]
    
    /// A closure that builds a `ScreenView` from a `Screen`.
    @ViewBuilder var buildView: (Screen) -> ScreenView
    
    /// Initializer for creating a NavigationStack using a binding to an array of screens.
    /// - Parameters:
    ///   - stack: A binding to an array of screens.
    ///   - buildView: A closure that builds a `ScreenView` from a `Screen`.
    public init(_ stack: Binding<[ScreenElement<Screen>]>, @ViewBuilder buildView: @escaping (Screen) -> ScreenView) {
        self._stack = stack
        self.buildView = buildView
    }
    
    public var body: some View {
        stack
            .enumerated()
            .reversed()
            .reduce(NavigationNode<Screen, ScreenView>.end) { presentedNode, new in
                return NavigationNode<Screen, ScreenView>.view(
                    buildView(new.element.screen),
                    presenting: presentedNode,
                    stack: $stack,
                    index: new.offset,
                    options: new.element.options)
            }
    }
}

public extension NavigationStack {
    
    /// Convenience initializer for creating an NavigationStack using a binding to a `NavigationFlow`
    /// of screens.
    /// - Parameters:
    ///   - stack: A binding to a NavigationFlow of screens.
    ///   - buildView: A closure that builds a `ScreenView` from a `Screen`.
    init(_ stack: Binding<NavigationFlow<Screen>>, @ViewBuilder buildView: @escaping (Screen) -> ScreenView) {
        self._stack = Binding(
            get: { stack.wrappedValue.screenElements },
            set: { stack.wrappedValue.screenElements = $0 }
        )
        self.buildView = buildView
    }
}

public extension NavigationStack {
    
    /// Convenience initializer for creating an NavigationStack using a binding to an array
    /// of screens, using the default presentation style.
    /// - Parameters:
    ///   - stack: A binding to an array of screens.
    ///   - buildView: A closure that builds a `ScreenView` from a `Screen`.
    init(_ stack: Binding<[Screen]>, @ViewBuilder buildView: @escaping (Screen) -> ScreenView) {
        self._stack = Binding(
            get: { stack.wrappedValue.map { ScreenElement(screen: $0, options: .init(style: .default, onDismiss: nil)) } },
            set: { stack.wrappedValue = $0.map { $0.screen } }
        )
        self.buildView = buildView
    }
}


