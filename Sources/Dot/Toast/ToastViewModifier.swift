//
//  ToastViewModifier.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

public struct ToastViewModifier: ViewModifier {
    
    @ObservedObject public var toast: Toast
    
    public func body(content: Content) -> some View {
        ZStack {
            content
            ToastView($toast.isPresented, config: $toast.config)
        }
    }
}

public extension View {
    /// Adds a Toast to the view
    /// - Parameter toast: Toast
    /// - Returns: a view with a Toast
    func uses(_ toast: Toast) -> some View {
        modifier(ToastViewModifier(toast: toast))
    }
    
    /// Adds a Toast to the view and sets it as an ``@EnvironmentObject``
    /// - Parameter toast: Toast
    /// - Returns: a view with a Toast
    func usesEnvironmentObject(_ toast: Toast) -> some View {
        self.uses(toast)
            .environmentObject(toast)
    }
}
