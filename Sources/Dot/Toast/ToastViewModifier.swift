//
//  ToastViewModifier.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

public struct ToastViewModifier: ViewModifier {
    
    @ObservedObject public var manager: ToastManager
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            ToastView($manager.isPresented, config: $manager.config)
        }
    }
}

public extension View {
    /// Adds a ToastManager to the view
    /// - Parameter manager: ToastManager
    /// - Returns: a view with a Toast
    func uses(_ manager: ToastManager) -> some View {
        modifier(ToastViewModifier(manager: manager))
    }
    
    /// Adds a ToastManager to the view and sets it as an ``@EnvironmentObject``
    /// - Parameter manager: ToastManager
    /// - Returns: a view with a Toast
    func usesEnvironmentObject(_ manager: ToastManager) -> some View {
        self.uses(manager)
            .environmentObject(manager)
    }
}
