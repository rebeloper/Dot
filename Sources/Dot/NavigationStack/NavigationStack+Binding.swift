//
//  NavigationStack+Binding.swift
//  
//
//  Created by Alex Nagy on 16.11.2021.
//

import SwiftUI

extension Binding {
    
    /// Appends a ``Page`` onto the ``NavigationStack``.
    /// - Parameter options: Navigation options for ``style`` and optional ``onDismiss``
    /// - Parameter completion: The closure to execute when finishing the navigation
    public func present<Page>(
        _ page: Page,
        options: NavigationOptions = .init(style: .default),
        completion: (() -> Void)?
    ) where Value == NavigationFlow<Page> {
        self.wrappedValue.pageElements.append(NavigationPageElement<Page>(page: page, options: options))
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.pushPresentMilliseconds)) {
            completion?()
        }
    }
    
    /// Appends a ``Page`` onto the ``NavigationStack``.
    /// - Parameter options: Navigation options for ``style`` and optional ``onDismiss``
    public func present<Page>(
        _ page: Page,
        options: NavigationOptions = .init(style: .default)
    ) where Value == NavigationFlow<Page> {
        present(page, options: options, completion: nil)
    }
    
    /// Pops the last ``Page`` from the ``NavigationStack``.
    /// - Parameter completion: The closure to execute when finishing the navigation
    public func pop<Page>(
        completion: @escaping () -> () = {}
    ) where Value == NavigationFlow<Page> {
        self.wrappedValue.pageElements = self.wrappedValue.pageElements.dropLast()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds)) {
            completion()
        }
    }
    
    /// Pops the specified last ``Page``s from the ``NavigationStack``.
    /// - Parameter last: The number of screens to be popped
    /// - Parameter popStyle: The style of the pop navigation, default is ``automatic``
    /// - Parameter completion: The closure to execute when finishing the navigation
    public func pop<Page>(
        last: Int,
        popStyle: NavigationPopStyle = .automatic,
        completion: @escaping () -> () = {}
    ) where Value == NavigationFlow<Page> {
        let pageElementsCount = wrappedValue.pageElements.count
        let last = last >= pageElementsCount ? pageElementsCount - 1 : last
        let toDrop = pageElementsCount - last
        var animatedNavigationSteps = 0
        let pageElements = wrappedValue.pageElements.dropFirst(toDrop).reversed()
        pageElements.forEach { pageElement in
            let style = pageElement.options.style
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * (animatedNavigationSteps))) {
                pop()
            }
            if style == .sheet || style == .fullScreenCover {
                animatedNavigationSteps += 1
            } else {
                if popStyle == .longest {
                    animatedNavigationSteps += 1
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * (animatedNavigationSteps))) {
            completion()
        }
    }
    
    /// Pops to the ``Page`` at the specified ``index`` in the ``NavigationStack``.
    /// - Parameter index: The index of the page to be popped to
    /// - Parameter popStyle: The style of the pop navigation, default is ``automatic``
    /// - Parameter completion: The closure to execute when finishing the navigation
    public func popTo<Page>(
        index: Int,
        popStyle: NavigationPopStyle = .automatic,
        completion: @escaping () -> () = {}
    ) where Value == NavigationFlow<Page> {
        guard index < wrappedValue.pageElements.count else { return }
        let index = index >= 0 ? index : 0
        let difference = wrappedValue.pageElements.count - index - 1
        let last = difference >= wrappedValue.pageElements.count ? wrappedValue.pageElements.count - 1 : difference
        pop(last: last, popStyle: popStyle, completion: completion)
    }
    
    /// Pops all the ``Page``s from the ``NavigationStack``.
    /// - Parameter popStyle: The style of the pop navigation, default is ``automatic``
    /// - Parameter completion: The closure to execute when finishing the navigation
    public func popToRoot<Page>(
        popStyle: NavigationPopStyle = .automatic,
        completion: @escaping () -> () = {}
    ) where Value == NavigationFlow<Page> {
        popTo(index: 0, popStyle: popStyle, completion: completion)
    }
    
}

