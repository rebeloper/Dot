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

    var minSize: CGSize
    var cornerRadius: CGFloat

    var backgroundColor: Color

    var titleForegroundColor: Color
    var messageForegroundColor: Color

    var shadowColor: Color
    var shadowRadius: CGFloat

    var borderColor: Color
    var borderWidth: CGFloat

    var shouldAutoHide: Bool
    var allowsTapToHide: Bool
    var autoHideInterval: TimeInterval
    var shouldDisableContent: Bool
    
    /// Creates a configuration for ToastView
    /// - Parameters:
    ///   - type: Toast type
    ///   - minSize: minimum size of the hud
    ///   - cornerRadius: Toast corner radius
    ///   - backgroundColor: Toast background color
    ///   - titleForegroundColor: title foreground color
    ///   - messageForegroundColor: message foreground color
    ///   - shadowColor: Toast shadow color
    ///   - shadowRadius: Toast shadow radius
    ///   - borderColor: Toast border color
    ///   - borderWidth: Toast border width
    ///   - shouldAutoHide: should the Toast auto hide
    ///   - allowsTapToHide: should the Toast allow tap to hide
    ///   - autoHideInterval: autohide time
    ///   - shouldDisableContent: should the Toast disable the underlying content
    public init(
        type: ToastType = .top,
        minSize: CGSize = CGSize(width: 100.0, height: 100.0),
        cornerRadius: CGFloat = 18.0,
        backgroundColor: Color = .clear,
        titleForegroundColor: Color = .primary,
        messageForegroundColor: Color = .secondary,
        shadowColor: Color = .clear,
        shadowRadius: CGFloat = 0.0,
        borderColor: Color = .clear,
        borderWidth: CGFloat = 0.0,
        shouldAutoHide: Bool = false,
        allowsTapToHide: Bool = false,
        autoHideInterval: TimeInterval = 10.0,
        shouldDisableContent: Bool = true
    ) {
        self.type = type
        
        self.minSize = minSize
        self.cornerRadius = cornerRadius

        self.backgroundColor = backgroundColor

        self.titleForegroundColor = titleForegroundColor
        self.messageForegroundColor = messageForegroundColor

        self.shadowColor = shadowColor
        self.shadowRadius = shadowRadius

        self.borderColor = borderColor
        self.borderWidth = borderWidth

        self.shouldAutoHide = shouldAutoHide
        self.allowsTapToHide = allowsTapToHide
        self.autoHideInterval = autoHideInterval
        
        self.shouldDisableContent = shouldDisableContent
    }
}

public enum ToastType {
    case top
    case center
    case bottom
}

private struct ToastLabelView: View {
    
    var type: ToastType
    
    var title: String?
    var message: String?
    
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
    var config: ToastConfig
    
    @Environment(\.colorScheme) private var colorScheme
    
    public init(_ isVisible: Binding<Bool>, config: ToastConfig) {
        self._isVisible = isVisible
        self.config = config
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
                                    ToastLabelView(type: config.type, title: config.title, message: config.message, titleForegroundColor: config.titleForegroundColor, messageForegroundColor: config.messageForegroundColor)
                                }
                            }
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(config.cornerRadius)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: config.cornerRadius)
                                    .stroke(config.borderColor, lineWidth: config.borderWidth)
                            )
                            .shadow(color: config.shadowColor, radius: config.shadowRadius)
                            
                            Spacer()
                        }
                        
                    case .center:
                        VStack(spacing: 20) {
                            ProgressView()
                            if config.title != nil {
                                ToastLabelView(type: config.type, title: config.title, message: config.message, titleForegroundColor: config.titleForegroundColor, messageForegroundColor: config.messageForegroundColor)
                            }
                        }
                        .padding()
                        .background(.thinMaterial)
                        .cornerRadius(config.cornerRadius)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: config.cornerRadius)
                                .stroke(config.borderColor, lineWidth: config.borderWidth)
                        )
                        .shadow(color: config.shadowColor, radius: config.shadowRadius)
                        
                    case .bottom:
                        VStack {
                            Spacer()
                            
                            HStack(spacing: 12) {
                                ProgressView()
                                if config.title != nil {
                                    ToastLabelView(type: config.type, title: config.title, message: config.message, titleForegroundColor: config.titleForegroundColor, messageForegroundColor: config.messageForegroundColor)
                                }
                            }
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(config.cornerRadius)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: config.cornerRadius)
                                    .stroke(config.borderColor, lineWidth: config.borderWidth)
                            )
                            .shadow(color: config.shadowColor, radius: config.shadowRadius)
                        }
                        
                    }
                    
                }
            }
            .animation(.spring(), value: 1)
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

