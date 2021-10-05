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
    @Published public var isPresentedDate: Date = Date()
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
    ///   - throttle: delay for the presentation; default is `0.5` to present the Toast only if it was not dismissed before our delay
    public func present(_ title: String? = nil, message: String? = nil, after: Double = 0, throttle: Double = 0.5) {
        shouldPresent = true
        DispatchQueue.main.asyncAfter(deadline: .now() + after + throttle) {
            if self.shouldPresent {
                self.isPresentedDate = Date()
                self.config.title = title
                self.config.message = message
                withAnimation {
                    self.isPresented = true
                }
            }
        }
    }
    
    /// Dismisses the Toast
    /// - Parameters:
    ///    - after: delay for the dismiss; default is `0`
    ///    - throttle: delay for the dismiss; default is `0.5` to delay the dismiss of the Toast if it was presented before our delay duration
    public func dismiss(after: Double = 0, throttle: Double = 0.5) {
        var wait: Double = 0
        let isPresentedDuration = isPresentedDate.timeIntervalSinceNow + after
        print("isPresentedDuration: \(isPresentedDuration)")
        if isPresentedDuration < throttle {
            wait = 0.5
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + after + wait) {
            self.shouldPresent = false
            withAnimation {
                self.isPresented = false
            }
        }
    }
    
}

