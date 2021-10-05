//
//  Toast.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

public class Toast: ObservableObject {
    
    @Published public var isPresented: Bool = false
    @Published public var shouldPresent: Bool = false
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
        isThrottled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + config.throttle) {
            self.isThrottled = false
            if shouldPresent {
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
        let isThrottled = isThrottled
        shouldPresent = !isThrottled
        let minPresentedTime: Double = mayDismiss ? 0 : isThrottled ? 0 : config.minPresentedTime
        DispatchQueue.main.asyncAfter(deadline: .now() + config.throttle + minPresentedTime) {
            if isThrottled {
                self.isPresented = false
            } else {
                withAnimation {
                    self.isPresented = false
                }
            }
        }
    }
    
}

