//
//  NavigationNode.swift
//  
//
//  Created by Alex Nagy on 16.11.2021.
//

import Foundation
import SwiftUI

/// A view that represents a linked list of views, each presenting the next in
/// a navigation stack.
indirect enum NavigationNode<Page, V: View>: View {
    
    case view(V, presenting: NavigationNode<Page, V>, stack: Binding<[NavigationPageElement<Page>]>, index: Int, options: NavigationOptions)
    case end
    
    private var isActiveBinding: Binding<Bool> {
        switch self {
        case .end, .view(_, .end, _, _, _):
            return .constant(false)
        case .view(_, .view, let stack, let index, _):
            return Binding(
                get: {
                    return stack.wrappedValue.count > index + 1
                },
                set: { isPresented in
                    guard !isPresented else { return }
                    guard stack.wrappedValue.count > index + 1 else { return }
                    stack.wrappedValue = Array(stack.wrappedValue.prefix(index + 1))
                }
            )
        }
    }
    
    @ViewBuilder
    private var presentingView: some View {
        switch self {
        case .end:
            EmptyView()
        case .view(let view, _, _, _, _):
            view
        }
    }
    
    @ViewBuilder
    private var presentedView: some View {
        switch self {
        case .end:
            EmptyView()
        case .view(_, let node, _, _, _):
            node
        }
    }
    
    private var navigationOptions: NavigationOptions? {
        switch self {
        case .end, .view(_, .end, _, _, _):
            return nil
        case .view(_, .view(_, _, _, _, let options), _, _, _):
            return options
        }
    }
    
    var body: some View {
        presentingView
            .background(
                NavigationLink(destination: presentedView
                                .onDisappear(perform: {
                                    if (navigationOptions?.style == NavigationStyle.regular(isDetailLink: true) || navigationOptions?.style == NavigationStyle.regular(isDetailLink: false)), !isActiveBinding.wrappedValue {
                                        navigationOptions?.onDismiss?()
                                    }
                                }),
                               isActive: navigationOptions?.style == NavigationStyle.regular(isDetailLink: true) || navigationOptions?.style == NavigationStyle.regular(isDetailLink: false) ? isActiveBinding : .constant(false),
                               label: EmptyView.init)
                    .isDetailLink(navigationOptions?.style == NavigationStyle.regular(isDetailLink: true) ? true : false)
                    .hidden()
            )
            .fullScreenCover(
                isPresented: navigationOptions?.style == .fullScreenCover || navigationOptions?.style == .navigatableFullScreenCover ? isActiveBinding : .constant(false),
                onDismiss: navigationOptions?.onDismiss,
                content: {
                    if navigationOptions?.style == .navigatableFullScreenCover {
                        presentedView.navigatable()
                    } else {
                        presentedView
                    }
                }
            )
            .sheet(
                isPresented: navigationOptions?.style == .sheet || navigationOptions?.style == .navigatableSheet ? isActiveBinding : .constant(false),
                onDismiss: navigationOptions?.onDismiss,
                content: {
                    if navigationOptions?.style == .navigatableSheet {
                        presentedView.navigatable()
                    } else {
                        presentedView
                    }
                }
            )
    }
}

