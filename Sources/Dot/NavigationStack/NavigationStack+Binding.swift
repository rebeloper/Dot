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
    
    /// Pops all the ``Page``s from the ``NavigationStack``.
    /// - Parameter completion: The closure to execute when finishing the navigation
    public func popToRoot<Page>(
        completion: @escaping () -> () = {}
    ) where Value == NavigationFlow<Page> {
        for index in 0..<wrappedValue.pageElements.count - 1 {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * index)) {
                pop()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * (wrappedValue.pageElements.count - 1))) {
            completion()
        }
    }
    
    /// Pops the last ``Page`` from the ``NavigationStack``.
    /// - Parameter completion: The closure to execute when finishing the navigation
    public func pop2<Page>(
        completesInstantly: Bool = false,
        completion: @escaping () -> () = {}
    ) where Value == NavigationFlow<Page> {
        self.wrappedValue.pageElements = self.wrappedValue.pageElements.dropLast()
        if completesInstantly {
            completion()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds)) {
                completion()
            }
        }
    }
    
    /// Pops all the ``Page``s from the ``NavigationStack``.
    /// - Parameter completion: The closure to execute when finishing the navigation
    public func popToRoot2<Page>(
        isStepped: Bool = true,
        completion: @escaping () -> () = {}
    ) where Value == NavigationFlow<Page> {
        var animatedNavigationSteps = 0
        let pageElements = wrappedValue.pageElements
        for i in 0..<pageElements.count - 1 {
            let pageElement = pageElements[pageElements.count - i]
            let style = pageElement.options.style
            if style == .sheet || style == .fullScreenCover {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * animatedNavigationSteps)) {
                    pop2()
                }
                animatedNavigationSteps += 1
            } else {
                if isStepped {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * animatedNavigationSteps)) {
                        pop2(completesInstantly: isStepped ? false : true)
                    }
                    animatedNavigationSteps += 1
                } else {
                    pop2(completesInstantly: isStepped ? false : true)
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * (animatedNavigationSteps))) {
            completion()
        }
    }
    
    /// Pops the specified last ``Page``s from the ``NavigationStack``.
    /// - Parameter last: The number of screens to be popped; default is 1
    /// - Parameter completion: The closure to execute when finishing the navigation
    public func pop<Page>(
        last: Int = 1,
        completion: @escaping () -> () = {}
    ) where Value == NavigationFlow<Page> {
        let last = last >= wrappedValue.pageElements.count ? wrappedValue.pageElements.count - 1 : last
        for index in 0..<last {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * index)) {
                self.pop()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * last)) {
            completion()
        }
    }
    
    /// Pops to the ``Page`` at the specified ``index`` in the ``NavigationStack``.
    /// - Parameter index: The index of the page to be popped to
    /// - Parameter completion: The closure to execute when finishing the navigation
    public func popTo<Page>(
        index: Int,
        completion: @escaping () -> () = {}
    ) where Value == NavigationFlow<Page> {
        guard index < wrappedValue.pageElements.count else { return }
        let index = index >= 0 ? index : 0
        let difference = wrappedValue.pageElements.count - index - 1
        let last = difference >= wrappedValue.pageElements.count ? wrappedValue.pageElements.count - 1 : difference
        for index in 0..<last {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * index)) {
                self.pop()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * last)) {
            completion()
        }
    }
    
    /// Replaces the ``NavigationStack`` flow's current ``Page``s with a new set of ``Page``s
    /// - Parameter newPageElements: The new page elements set
    /// - Parameter completion: The closure to execute when finishing the navigation
    public func replaceNavigationFlow<Page>(
        newPageElements: [NavigationPageElement<Page>],
        completion: @escaping () -> () = {}
    ) where Value == NavigationFlow<Page> {
        popToRoot {
            self.wrappedValue.pageElements = []
            for (index, screenElement) in newPageElements.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * index)) {
                    self.wrappedValue.pageElements.append(screenElement)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(wrappedValue.popMilliseconds * newPageElements.count)) {
                completion()
            }
        }
    }
}

