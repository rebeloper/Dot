//
//  SimpleTimer.swift
//  Dot
//
//  Created by Alex Nagy on 08.09.2021.
//

import Foundation
import Combine

public class SimpleTimer {
    // the interval at which the timer ticks
    private let interval: TimeInterval
    // the action to take when the timer ticks
    private let onTick: () -> Void
    
    private var timer: Publishers.Autoconnect<Timer.TimerPublisher>? = nil
    private var subscription: AnyCancellable? = nil
    
    public init(interval: TimeInterval, onTick: @escaping () -> Void) {
        self.interval = interval
        self.onTick = onTick
    }
    
    public var isRunning: Bool {
        timer != nil
    }
    
    // start the timer and begin ticking
    public func start() {
        timer = Timer.publish(every: interval, on: .main, in: .common).autoconnect()
        subscription = timer?.sink(receiveValue: { _ in
            self.onTick()
        })
    }
    
    // cancel the timer and clean up its resources
    public func cancel() {
        timer?.upstream.connect().cancel()
        timer = nil
        subscription = nil
    }
}

