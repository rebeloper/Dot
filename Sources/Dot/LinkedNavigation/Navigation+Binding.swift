//
//  Navigation+Binding.swift
//  
//
//  Created by Alex Nagy on 16.11.2021.
//

import SwiftUI

extension Binding {
    
    /// Appends a ``Screen`` onto the ``NavigationStack``.
    /// - Parameter options: Navigation options for ``style`` and optional ``onDismiss``
    /// - Parameter completion: The closure to execute when finishing the navigation
    public func present<Screen>(_ screen: Screen,
                                options: NavigationOptions = .init(style: .default),
                                completion: (() -> Void)?) where Value == NavigationFlow<Screen> {
        self.wrappedValue.screenElements.append(ScreenElement<Screen>(screen: screen, options: options))
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.pushPresentMilliseconds)) {
            completion?()
        }
    }
    
    /// Appends a ``Screen`` onto the ``NavigationStack``.
    /// - Parameter options: Navigation options for ``style`` and optional ``onDismiss``
    public func present<Screen>(_ screen: Screen,
                                options: NavigationOptions = .init(style: .default)) where Value == NavigationFlow<Screen> {
        present(screen, options: options, completion: nil)
    }
    
    /// Pops the last ``Screen`` from the ``NavigationStack``.
    /// - Parameter completion: The closure to execute when finishing the navigation
    public func pop<Screen>(completion: @escaping () -> () = {}) where Value == NavigationFlow<Screen> {
        self.wrappedValue.screenElements = self.wrappedValue.screenElements.dropLast()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds)) {
            completion()
        }
    }
    
    /// Pops all the ``Screen``s from the ``NavigationStack``.
    /// - Parameter completion: The closure to execute when finishing the navigation
    public func popToRoot<Screen>(completion: @escaping () -> () = {}) where Value == NavigationFlow<Screen> {
        for index in 0..<wrappedValue.screenElements.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * index)) {
                pop()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * (wrappedValue.screenElements.count - 1))) {
            completion()
        }
    }
    
    /// Pops the specified last ``Screen``s from the ``NavigationStack``.
    /// - Parameter last: The number of screens to be popped; default is 1
    /// - Parameter completion: The closure to execute when finishing the navigation
    public func pop<Screen>(last: Int = 1, completion: @escaping () -> () = {}) where Value == NavigationFlow<Screen> {
        let last = last >= wrappedValue.screenElements.count ? wrappedValue.screenElements.count - 1 : last
        for index in 0..<last {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * index)) {
                self.pop()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * last)) {
            completion()
        }
    }
    
    /// Pops to the ``Screen`` at the specified ``index`` in the ``NavigationStack``.
    /// - Parameter index: The index of the screen to be popped to
    /// - Parameter completion: The closure to execute when finishing the navigation
    public func popTo<Screen>(index: Int, completion: @escaping () -> () = {}) where Value == NavigationFlow<Screen> {
        guard index < wrappedValue.screenElements.count else { return }
        let index = index >= 0 ? index : 0
        let difference = wrappedValue.screenElements.count - index - 1
        let last = difference >= wrappedValue.screenElements.count ? wrappedValue.screenElements.count - 1 : difference
        for index in 0..<last {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * index)) {
                self.pop()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * last)) {
            completion()
        }
    }
    
    /// Pops to the specified ``Screen`` in the ``NavigationStack``.
    /// - Parameter screen: the screen to be popped to
    /// - Parameter completion: The closure to execute when finishing the navigation
    public func popTo<Screen: Equatable>(screen: Screen, completion: @escaping () -> () = {}) where Value == NavigationFlow<Screen> {
        var last = 0
        for screenElemet in wrappedValue.screenElements.reversed() {
            let theScreen = screenElemet.screen
            if screen != theScreen {
                last += 1
            }
        }
        last -= 1
        for index in 0..<last {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * index)) {
                self.pop()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * last)) {
            completion()
        }
    }
    
    /// Replaces the ``NavigationStack`` flow's current ``Screen``s with a new set of ``Screen``s
    /// - Parameter newScreenElements: The new screen elements set
    /// - Parameter completion: The closure to execute when finishing the navigation
    public func replaceNavigationFlow<Screen>(newScreenElements: [ScreenElement<Screen>], completion: @escaping () -> () = {}) where Value == NavigationFlow<Screen> {
        popToRoot {
            self.wrappedValue.screenElements = []
            for (index, screenElement) in newScreenElements.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * index)) {
                    self.wrappedValue.screenElements.append(screenElement)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * newScreenElements.count)) {
                completion()
            }
        }
    }
}


