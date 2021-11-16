//
//  Navigation+Binding.swift
//  
//
//  Created by Alex Nagy on 16.11.2021.
//

import SwiftUI

extension Binding {
    
    /// Pushes a new screen onto the stack by pushing it.
    /// - Parameter screen: The screen to push.
    /// - Parameter completion: callback called after the navigation ended
    public func push<Screen>(_ screen: Screen, completion: @escaping () -> () = {}) where Value == NavigationFlow<Screen> {
        self.wrappedValue.screenElements.append(ScreenElement(screen: screen, options: .init(style: ._pushNotAvailable, onDismiss: nil)))
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.pushPresentMilliseconds)) {
            completion()
        }
    }
    
    /// Pushes a new screen onto the stack by presenting it.
    /// - Parameter screen: The screen to present.
    /// - Parameter style: How to present the screen.
    /// - Parameter onDismiss: Called when the presented view is later
    /// dismissed.
    /// - Parameter completion: callback called after the navigation ended
    public func present<Screen>(_ screen: Screen, style: NavigationPresentationStyle, onDismiss: (() -> Void)?, completion: @escaping () -> () = {}) where Value == NavigationFlow<Screen> {
        guard style != ._pushNotAvailable else {
            print("Navigation Error: the NavigationPresentationStyle '_pushNotAvailable' is not allowed in this context. Please use one of the other styles. If you wanted to 'push' the view instead of 'present(_:, style:, onDismiss:' use 'push(_:)'")
            return
        }
        let options = NavigationPresentationOptions(style: style, onDismiss: onDismiss)
        self.wrappedValue.screenElements.append(ScreenElement<Screen>(screen: screen, options: options))
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.pushPresentMilliseconds)) {
            completion()
        }
    }
    
    /// Pops all the screen off the navigation stack till the root.
    /// - Parameter completion: callback called after the navigation ended
    public func pop<Screen>(completion: @escaping () -> () = {}) where Value == NavigationFlow<Screen> {
        self.wrappedValue.screenElements = self.wrappedValue.screenElements.dropLast()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds)) {
            completion()
        }
    }
    
    /// Pops all the screen off the navigation stack till the root.
    /// - Parameter completion: callback called after the navigation ended
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
    
    /// Pops the set amount of last screens off the navigation stack.
    /// - Parameter last: the number of screens to be popped; default is 1
    /// - Parameter completion: callback called after the navigation ended
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
    
    /// Pops to the screen with the set index in the navigation stack.
    /// - Parameter index: the index of the screen to be popped to
    /// - Parameter completion: callback called after the navigation ended
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
    
    /// Pops to the specified screen in the navigation stack.
    /// - Parameter screen: the screen to be popped to
    /// - Parameter completion: callback called after the navigation ended
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
    
    /// This method allows you to replace the NavigationFlow's current screens with a new set of screens
    /// - Parameter newScreenElements: the new screen elements set
    /// - Parameter completion: callback called after the navigation ended
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


