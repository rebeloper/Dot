//
//  TabBarModifier.swift
//  
//
//  Created by Alex Nagy on 20.09.2021.
//

import SwiftUI
import UIKit

public struct TabBarModifier {
    public static func shownTabBar() {
        UIApplication.shared.keyWindow?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.isHidden = false
            }
        })
    }
    
    public static func hiddenTabBar() {
        UIApplication.shared.keyWindow?.allSubviews().forEach({ subView in
            if let view = subView as? UITabBar {
                view.isHidden = true
            }
        })
    }
}

public struct ShowsTabBarViewModifier: ViewModifier {
    public func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            TabBarModifier.shownTabBar()
        }
    }
}

public struct HidesTabBarViewModifier: ViewModifier {
    public func body(content: Content) -> some View {
        return content.padding(.zero).onAppear {
            TabBarModifier.hiddenTabBar()
        }
    }
}

public extension View {
    
    func showsTabBar() -> some View {
        return self.modifier(ShowsTabBarViewModifier())
    }

    func hidesTabBar() -> some View {
        return self.modifier(HidesTabBarViewModifier())
    }
}
