//
//  ToastView.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

/// Configure the ToastView
public struct ToastConfig {
    var title: String?
    var message: String?
    
    var type: ToastType
    
    var throttle: Double
    var minPresentedTime: Double

    var minSize: CGSize
    var cornerRadius: CGFloat
    
    var material: Material

    var titleForegroundColor: Color
    var messageForegroundColor: Color

    var shadowColor: Color
    var shadowRadius: CGFloat

    var backgroundColor: Color
    
    var shouldAutoHide: Bool
    var allowsTapToHide: Bool
    var autoHideInterval: TimeInterval
    
    /// Creates a configuration for ToastView
    /// - Parameters:
    ///   - type: Toast type
    ///   - throttle: the throttle for the Toast to be presented and dismissed
    ///   - minPresentedTime: minimum time the Toast will be presented
    ///   - minSize: minimum size of the hud
    ///   - cornerRadius: Toast corner radius
    ///   - material: Toast material background
    ///   - titleForegroundColor: title foreground color
    ///   - messageForegroundColor: message foreground color
    ///   - shadowColor: Toast shadow color
    ///   - shadowRadius: Toast shadow radius
    ///   - backgroundColor: Toast background color
    ///   - shouldAutoHide: should the Toast auto hide
    ///   - allowsTapToHide: should the Toast allow tap to hide
    ///   - autoHideInterval: autohide time
    public init(
        type: ToastType = .top,
        throttle: Double = 0.5,
        minPresentedTime: Double = 1.0,
        minSize: CGSize = CGSize(width: 100.0, height: 100.0),
        cornerRadius: CGFloat = 18.0,
        material: Material = .thinMaterial,
        titleForegroundColor: Color = .primary,
        messageForegroundColor: Color = .secondary,
        shadowColor: Color = .clear,
        shadowRadius: CGFloat = 0.0,
        backgroundColor: Color = .black.opacity(0.2),
        shouldAutoHide: Bool = false,
        allowsTapToHide: Bool = false,
        autoHideInterval: TimeInterval = 10.0
    ) {
        self.type = type
        
        self.throttle = throttle
        self.minPresentedTime = minPresentedTime
        
        self.minSize = minSize
        self.cornerRadius = cornerRadius

        self.material = material

        self.titleForegroundColor = titleForegroundColor
        self.messageForegroundColor = messageForegroundColor

        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius

        self.backgroundColor = backgroundColor
        
        self.shouldAutoHide = shouldAutoHide
        self.allowsTapToHide = allowsTapToHide
        self.autoHideInterval = autoHideInterval
    }
}

public enum ToastType {
    case top
    case center
    case bottom
}

private struct ToastLabelView: View {
    
    var type: ToastType
    
    @Binding var title: String?
    @Binding var message: String?
    
    var titleForegroundColor: Color
    var messageForegroundColor: Color
    
    var body: some View {
        Group {
            switch type {
            case .top, .bottom:
                VStack(spacing: 4) {
                    if let title = title {
                        Text(title)
                            .font(.system(size: 12.0, weight: .semibold))
                            .lineLimit(2)
                            .foregroundColor(.primary)
                    }
                    if let message = message {
                        Text(message)
                            .lineLimit(2)
                            .font(.system(size: 11.0, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                }
            case .center:
                VStack(spacing: 4) {
                    if let title = title {
                        Text(title)
                            .font(.system(size: 16.0, weight: .semibold))
                            .lineLimit(2)
                            .foregroundColor(.primary)
                    }
                    if let message = message {
                        Text(message)
                            .lineLimit(2)
                            .font(.system(size: 14.0, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                }
            }
            
        }
        .multilineTextAlignment(.center)
    }
}

public struct ToastView: View {
    @Binding var isVisible: Bool
    @Binding var config: ToastConfig
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(_ isVisible: Binding<Bool>, config: Binding<ToastConfig>) {
        self._isVisible = isVisible
        self._config = config
    }
    
    public var body: some View {
        let hideTimer = Timer.publish(every: config.autoHideInterval, on: .main, in: .common).autoconnect()
        
        GeometryReader { geometry in
            ZStack {
                if isVisible {
                    config.backgroundColor
                        .edgesIgnoringSafeArea(.all)
                    
                    switch config.type {
                    case .top:
                        VStack {
                            HStack(spacing: 12) {
                                ProgressView()
                                if config.title != nil {
                                    ToastLabelView(type: config.type, title: $config.title, message: $config.message, titleForegroundColor: config.titleForegroundColor, messageForegroundColor: config.messageForegroundColor)
                                }
                            }
                            .padding()
                            .background(config.material)
                            .cornerRadius(config.cornerRadius)
                            .padding()
                            .shadow(color: config.shadowColor, radius: config.shadowRadius)
                            
                            Spacer()
                        }
                        .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
                        
                    case .center:
                        VStack(spacing: 20) {
                            ProgressView()
                            if config.title != nil {
                                ToastLabelView(type: config.type, title: $config.title, message: $config.message, titleForegroundColor: config.titleForegroundColor, messageForegroundColor: config.messageForegroundColor)
                            }
                        }
                        .padding()
                        .background(config.material)
                        .cornerRadius(config.cornerRadius)
                        .padding()
                        .shadow(color: config.shadowColor, radius: config.shadowRadius)
                        .transition(AnyTransition.opacity)
                        
                    case .bottom:
                        VStack {
                            Spacer()
                            
                            HStack(spacing: 12) {
                                ProgressView()
                                if config.title != nil {
                                    ToastLabelView(type: config.type, title: $config.title, message: $config.message, titleForegroundColor: config.titleForegroundColor, messageForegroundColor: config.messageForegroundColor)
                                }
                            }
                            .padding()
                            .background(config.material)
                            .cornerRadius(config.cornerRadius)
                            .padding()
                            .shadow(color: config.shadowColor, radius: config.shadowRadius)
                            
                        }
                        .transition(AnyTransition.move(edge: .bottom).combined(with: .opacity))
                        
                    }
                    
                }
            }
            .onTapGesture {
                if config.allowsTapToHide {
                    withAnimation {
                        isVisible = false
                    }
                }
            }
            .onReceive(hideTimer) { _ in
                if config.shouldAutoHide {
                    withAnimation {
                        isVisible = false
                    }
                }
                // Only one call required
                hideTimer.upstream.connect().cancel()
            }
        }
    }
    
}

