//
//  Toast.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

public class Toast: ObservableObject {
    
    @Published public var isPresented: Bool = false
    
    public var config: ToastConfig
    
    /// Creates a Toast
    /// - Parameter config: Toast Configuration
    public init(config: ToastConfig = ToastConfig()) {
        self.config = config
    }
    
    /// Presents a Toast
    /// - Parameters:
    ///   - title: title of the Toast
    ///   - message: message of the Toast
    public func present(_ title: String? = nil, message: String? = nil) {
        self.config.title = title
        self.config.message = message
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            withAnimation {
                isPresented = true
            }
        }
    }
    
    /// Dismisses the Toast
    public func dismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            withAnimation {
                isPresented = false
            }
        }
    }
    
}

public extension View {
    /// Adds a Toast to the view
    /// - Parameter toast: Toast
    /// - Returns: a view with a Toast
    func uses(_ toast: Toast) -> some View {
        self.modifier(ToastViewModifier(toast: toast))
    }
}


