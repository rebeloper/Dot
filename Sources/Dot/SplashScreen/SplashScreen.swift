//
//  SplashScreen.swift
//  Dot
//
//  Created by Alex Nagy on 14.09.2021.
//

import SwiftUI

struct SplashScreen<Content: View, Background: View>: View {
    
    @Binding private var isActive: Bool
    private var scale: CGFloat
    private var delay: CGFloat
    private var animation: SplashScreenAnimation
    private var animationValue: CGFloat
    private var animationDuration: CGFloat
    private var content: () -> Content
    private var background: () -> Background
    
    @State private var shouldAnimate = false
    @State private var shouldClose = false
    @State private var pulsates = true
    @State private var animationState = true
    
    init(isActive: Binding<Bool>,
         scale: CGFloat = 20,
         delay: CGFloat = 0.3,
         animation: SplashScreenAnimation = .scale,
         animationValue: CGFloat = 0.95,
         animationDuration: CGFloat = 1,
         @ViewBuilder content: @escaping () -> Content,
         @ViewBuilder background: @escaping () -> Background) {
        self._isActive = isActive
        self.scale = scale
        self.delay = delay
        self.animation = animation
        self.animationValue = animationValue
        self.animationDuration = animationDuration
        self.content = content
        self.background = background
    }
    
    var body: some View {
        ZStack {
            background().ignoresSafeArea()
            
            content()
                .scaleEffect(shouldClose ? scale : 1)
                .if(animation == .scale, transform: { view in
                    view.scaleEffect(animationState ? animationValue : 1)
                })
                .if(animation == .fadeInOut, transform: { view in
                    view.opacity(animationState ? Double(animationValue) : 1)
                })
                .if(animation == .wiggle, transform: { view in
                    view.rotationEffect(Angle(degrees: Double(animationState ? animationValue : -animationValue)))
                })
                .if(animation == .moveHorizontally, transform: { view in
                    view
                        .offset(x: animationState ? animationValue : -animationValue)
                })
                .if(animation == .moveVertically, transform: { view in
                    view
                        .offset(y: animationState ? animationValue : -animationValue)
                })
                .onChange(of: isActive, perform: { isActive in
                    if !isActive {
                        DispatchQueue.main.async {
                            pulsates = false
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
        withAnimation(.easeInOut(duration: animationDuration).repeatForever(while: $pulsates)) {
            animationState.toggle()
        }
    }
}

enum SplashScreenAnimation {
    case none, scale, fadeInOut, wiggle, moveHorizontally, moveVertically
}


extension View {
    func splashScreen<Content: View, Background: View>(isActive: Binding<Bool>,
                                                       scale: CGFloat = 20,
                                                       delay: CGFloat = 0.3,
                                                       animation: SplashScreenAnimation = .scale,
                                                       animationValue: CGFloat = 0.95,
                                                       animationDuration: CGFloat = 1,
                                                       @ViewBuilder content: @escaping () -> Content,
                      @ViewBuilder background: @escaping () -> Background) -> some View {
        self.overlay(
            SplashScreen(isActive: isActive,
                         scale: scale,
                         delay: delay,
                         animation: animation,
                         animationValue: animationValue,
                         animationDuration: animationDuration,
                         content: content,
                         background: background)
        )
    }
}
