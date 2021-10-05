//
//  Toast.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

public class Toast: ObservableObject {
    
    @Published private var shouldPresent: Bool = false
    @Published public var isPresented: Bool = false
    @Published private var mayDismiss: Bool = false
    @Published private var isThrottled: Bool = false
    @Published public var config: ToastConfig
    
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
        shouldPresent = true
        mayDismiss = false
        DispatchQueue.main.asyncAfter(deadline: .now() + config.throttle) {
            if self.shouldPresent {
                self.config.title = title
                self.config.message = message
                withAnimation {
                    self.isPresented = true
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + config.throttle + config.minPresentedTime) {
            self.mayDismiss = true
        }
    }
    
    /// Dismisses the Toast
    public func dismiss() {
        let minPresentedTime: Double = mayDismiss ? 0 : config.minPresentedTime
        DispatchQueue.main.asyncAfter(deadline: .now() + config.throttle) {
            self.shouldPresent = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + config.throttle + minPresentedTime) {
            withAnimation {
                self.isPresented = false
            }
        }
    }
    
}

