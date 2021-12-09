//
//  NavigationStack.swift
//
//
//  Created by Alex Nagy on 07.12.2021.
//

import Foundation
import SwiftUI

/// NavigationStack maintains a stack of presented views.
public struct NavigationStack<Page, PageView: View>: View {
    
    /// The array of screens that represents the navigation stack.
    @Binding var stack: [NavigationPageElement<Page>]
    
    /// The style of the navigation view
    var style: NavigationStackStyle
    
    /// A closure that builds a `PageView` from a `Page`.
    @ViewBuilder var pageBuilder: (Page) -> PageView
    
    /// Initializer for creating a NavigationStack using a binding to an array of screens.
    /// - Parameters:
    ///   - stack: A binding to an array of screens.
    ///   - style: NavigationView Style
    ///   - pageBuilder: A closure that builds a `PageView` from a `Page`.
    public init(
        _ stack: Binding<[NavigationPageElement<Page>]>,
        style: NavigationStackStyle = .stack,
        @ViewBuilder pageBuilder: @escaping (Page) -> PageView
    ) {
        self._stack = stack
        self.style = style
        self.pageBuilder = pageBuilder
    }
    
    public var body: some View {
        NavigationView {
            stack
                .enumerated()
                .reversed()
                .reduce(NavigationNode<Page, PageView>.end) { presentedNode, new in
                    return NavigationNode<Page, PageView>.view(
                        pageBuilder(new.element.page),
                        presenting: presentedNode,
                        stack: $stack,
                        index: new.offset,
                        options: new.element.options)
                }
        }
        .if(style == .automatic, transform: { view in
            view.navigationViewStyle(.automatic)
        })
            .if(style == .stack, transform: { view in
                view.navigationViewStyle(.stack)
            })
            .if(style == .columns, transform: { view in
                view.navigationViewStyle(.columns)
            })
    }
    
}

public extension NavigationStack {
    
    /// Convenience initializer for creating an NavigationStack using a binding to a `NavigationFlow`
    /// of screens.
    /// - Parameters:
    ///   - stack: A binding to a NavigationFlow of screens.
    ///   - style: NavigationView Style
    ///   - pageBuilder: A closure that builds a `PageView` from a `Page`.
    init(
        _ stack: Binding<NavigationFlow<Page>>,
        style: NavigationStackStyle = .stack,
        @ViewBuilder pageBuilder: @escaping (Page) -> PageView
    ) {
        self._stack = Binding(
            get: { stack.wrappedValue.pageElements },
            set: { stack.wrappedValue.pageElements = $0 }
        )
        self.style = style
        self.pageBuilder = pageBuilder
    }
}

public extension NavigationStack {
    
    /// Convenience initializer for creating an NavigationStack using a binding to an array
    /// of screens, using the default presentation style.
    /// - Parameters:
    ///   - stack: A binding to an array of screens.
    ///   - style: NavigationView Style
    ///   - pageBuilder: A closure that builds a `PageView` from a `Page`.
    init(
        _ stack: Binding<[Page]>,
        style: NavigationStackStyle = .stack,
        @ViewBuilder pageBuilder: @escaping (Page) -> PageView
    ) {
        self._stack = Binding(
            get: { stack.wrappedValue.map { NavigationPageElement(page: $0, options: .init(style: .default, onDismiss: nil)) } },
            set: { stack.wrappedValue = $0.map { $0.page } }
        )
        self.style = style
        self.pageBuilder = pageBuilder
    }
}

