//
//  SplashScreen.swift
//  Dot
//
//  Created by Alex Nagy on 14.09.2021.
//

import SwiftUI

public struct SplashScreen<Content: View, Background: View>: View {
    
    @Binding private var isActive: Bool
    private var scale: CGFloat
    private var delay: CGFloat
    private var pulseScale: CGFloat
    private var animationDuration: CGFloat
    private var animation: SplashScreenAnimation
    private var content: () -> Content
    private var background: () -> Background
    
    @State private var shouldAnimate = false
    @State private var shouldClose = false
    @State private var pulsates = true
    
    /// Splash screen; add this to the root view of your app
    /// - isActive: is the splash screen active
    /// - scale: the scale of the content when the splash view is dismissed
    /// - delay: the delay of animation when the splash view is dismissed
    /// - pulseScale: the value the pulse animation has
    /// - animationDuration: the duration of the animation
    /// - animation: the pulse animation
    /// - content: the content that is centered in the splash screen
    /// - background: the background of the splash screen
    public init(isActive: Binding<Bool>,
                scale: CGFloat = 20,
                delay: CGFloat = 0.3,
                pulseScale: CGFloat = 0.95,
                animationDuration: CGFloat = 1,
                animation: SplashScreenAnimation = .scale,
                @ViewBuilder content: @escaping () -> Content,
                @ViewBuilder background: @escaping () -> Background) {
        self._isActive = isActive
        self.scale = scale
        self.delay = delay
        self.pulseScale = pulseScale
        self.animationDuration = animationDuration
        self.animation = animation
        self.content = content
        self.background = background
    }
    
    public var body: some View {
        ZStack {
            background().ignoresSafeArea()
            
            content()
                .scaleEffect(shouldClose ? scale : 1)
                .if(animation == .scale, transform: { view in
                    view.scaleEffect(pulsates ? pulseScale : 1)
                })
                .if(animation == .fadeInOut, transform: { view in
                    view.opacity(pulsates ? Double(pulseScale) : 1)
                })
                .if(animation == .wiggle, transform: { view in
                    view.rotationEffect(Angle(degrees: Double(pulsates ? pulseScale : -pulseScale)))
                })
                .if(animation == .moveHorizontally, transform: { view in
                    view
                        .offset(x: pulsates ? pulseScale : -pulseScale)
                })
                .if(animation == .moveVertically, transform: { view in
                    view
                        .offset(y: pulsates ? pulseScale : -pulseScale)
                })
                .onChange(of: isActive, perform: { isActive in
                    if !isActive {
                        DispatchQueue.main.async {
                            withAnimation {
                                shouldAnimate = true
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(Int(delay * 10))) {
                            withAnimation {
                                shouldClose = true
                            }
                        }
                    }
                })
        }
        .opacity(shouldClose ? 0 : 1)
        .onAppear {
            pulsate()
        }
    }
    
    private func pulsate() {
        withAnimation(.easeInOut(duration: Double(animationDuration)).repeatForever(while: !shouldAnimate)) {
            if shouldAnimate { return }
            pulsates.toggle()
        }
    }
}

public enum SplashScreenAnimation {
    case none, scale, fadeInOut, wiggle, moveHorizontally, moveVertically
}


public extension View {
    
    /// Splash screen; add this to the root view of your app
    /// - isActive: is the splash screen active
    /// - scale: the scale of the content when the splash view is dismissed
    /// - delay: the delay of animation when the splash view is dismissed
    /// - pulseScale: the value the pulse animation has
    /// - animationDuration: the duration of the animation
    /// - animation: the pulse animation
    /// - content: the content that is centered in the splash screen
    /// - background: the background of the splash screen
    func splashScreen<Content: View, Background: View>(isActive: Binding<Bool>,
                                                       scale: CGFloat = 20,
                                                       delay: CGFloat = 0.3,
                                                       pulseScale: CGFloat = 0.95,
                                                       animationDuration: CGFloat = 1,
                                                       animation: SplashScreenAnimation = .scale,
                                                       @ViewBuilder content: @escaping () -> Content,
                                                       @ViewBuilder background: @escaping () -> Background) -> some View {
        self.overlay(
            SplashScreen(isActive: isActive, scale: scale, delay: delay, pulseScale: pulseScale, animationDuration: animationDuration, animation: animation, content: content, background: background)
        )
    }
}

