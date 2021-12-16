////
////  ToastManager.swift
////  Dot
////
////  Created by Alex Nagy on 10.08.2021.
////
//
//import SwiftUI
//
//public class ToastManager: ObservableObject {
//
//    @Published var isPresented: Bool = false
//    @Published var shouldPresent: Bool = false
//    @Published var mayDismiss: Bool = false
//    @Published var isThrottled: Bool = false
//    @Published var config: ToastConfig
//
//    /// Creates a ToastManager
//    /// - Parameter config: ToastManager Configuration
//    public init(config: ToastConfig = ToastConfig()) {
//        self.config = config
//    }
//
//    /// Presents a Toast
//    /// - Parameters:
//    ///   - title: title of the Toast
//    ///   - message: message of the Toast
//    func present(_ title: String? = nil, message: String? = nil) {
//        DispatchQueue.main.async {
//            self.shouldPresent = true
//            self.mayDismiss = false
//            self.isThrottled = true
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + config.throttle) {
//            self.isThrottled = false
//            if self.shouldPresent {
//                self.config.title = title
//                self.config.message = message
//                withAnimation {
//                    self.isPresented = true
//                }
//            }
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + config.throttle + config.minPresentedTime) {
//            self.mayDismiss = true
//        }
//    }
//
//    /// Dismisses the Toast
//    func dismiss() {
//        if isThrottled {
//            DispatchQueue.main.async {
//                self.shouldPresent = false
//            }
//        } else {
//            let minPresentedTime: Double = mayDismiss ? 0 : config.minPresentedTime
//            DispatchQueue.main.asyncAfter(deadline: .now() + minPresentedTime) {
//                withAnimation {
//                    self.isPresented = false
//                }
//            }
//        }
//    }
//
//}
//

//
//  ToastManager.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI
import Combine

public class ToastManager: ObservableObject {
    
    @Published var isPresented: Bool = false
    @Published var shouldPresent: Bool = false
    @Published var config: ToastConfig
    @Published var timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    var cancellables = Set<AnyCancellable>()
    
    /// Creates a ToastManager
    /// - Parameter config: ToastManager Configuration
    public init(config: ToastConfig = ToastConfig()) {
        self.config = config
    }
    
    /// Presents a Toast
    /// - Parameters:
    ///   - title: title of the Toast
    ///   - message: message of the Toast
    func present(_ title: String? = nil, message: String? = nil) {
        
        if config.enableDebug {
            print("Should Present Toast")
        }
        DispatchQueue.main.async {
            self.shouldPresent = true
        }
        
        let date = Date()
        
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
        
        timer
            .map({ (output) in
                return output.timeIntervalSince(date)
            })
            .map({ (timeInterval) in
                return Double(timeInterval)
            })
            .sink { (seconds) in
                if self.shouldPresent {
                    if !self.isPresented, seconds >= self.config.throttle {
                        DispatchQueue.main.async {
                            self.config.title = title
                            self.config.message = message
                            withAnimation {
                                if self.config.enableDebug {
                                    print("Presenting Toast: \(seconds)")
                                }
                                self.isPresented = true
                            }
                        }
                    }
                } else {
                    if self.isPresented {
                        DispatchQueue.main.asyncAfter(deadline: .now() + (seconds <= (self.config.throttle + 0.5) ? self.config.minPresentedTime : 0)) {
                            withAnimation {
                                if self.config.enableDebug {
                                    print("Dismsissing Toast: \(seconds)")
                                }
                                self.isPresented = false
                            }
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    /// Dismisses the Toast
    func dismiss() {
        DispatchQueue.main.async {
            if self.config.enableDebug {
                print("Should Dismsiss Toast")
            }
            self.shouldPresent = false
        }
    }
    
}

