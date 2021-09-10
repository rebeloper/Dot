//
//  NavigationBarModifier.swift
//  Dot
//
//  Created by Alex Nagy on 10.09.2021.
//

import SwiftUI
import UIKit

public struct NavigationBarModifier: ViewModifier {
    var backgroundColor: UIColor
    var foregroundColor: UIColor
    var material: Material?
    var isDividerEnabled: Bool
    
    /// Sets the navigation bar appearance
    /// - Parameters:
    ///   - backgroundColor: background color
    ///   - foregroundColor: foreground color
    ///   - material: background material; replaces the background color
    ///   - isDividerEnabled: is the divider visible
    public init(backgroundColor: UIColor, foregroundColor: UIColor, material: Material? = nil, isDividerEnabled: Bool = false) {
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.material = material
        self.isDividerEnabled = isDividerEnabled
        let coloredAppearance = UINavigationBarAppearance()
        if isDividerEnabled {
            coloredAppearance.configureWithOpaqueBackground()
        } else {
            coloredAppearance.configureWithTransparentBackground()
        }
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: foregroundColor]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: foregroundColor]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = foregroundColor
    }
    
    public func body(content: Content) -> some View {
        ZStack{
            content
            VStack {
                GeometryReader { geometry in
                    VStack {
                        if let material = material {
                            Color.clear.opacity(0)
                                .frame(height: geometry.safeAreaInsets.top)
                                .background(material)
                        } else {
                            Color(self.backgroundColor)
                                .frame(height: geometry.safeAreaInsets.top)
                        }
                    }
                    .edgesIgnoringSafeArea(.top)
                        
                    Spacer()
                }
            }
        }
    }
}

public extension View {
    
    /// Sets the navigation bar appearance
    /// - Parameters:
    ///   - backgroundColor: background color
    ///   - foregroundColor: foreground color
    ///   - isDividerEnabled: is the divider visible
    func navigationBar(backgroundColor: UIColor, foregroundColor: UIColor, isDividerEnabled: Bool = false) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, foregroundColor: foregroundColor, material: nil, isDividerEnabled: isDividerEnabled))
    }
    
    /// Sets the navigation bar appearance
    /// - Parameters:
    ///   - backgroundMaterial: background material
    ///   - foregroundColor: foreground color
    ///   - isDividerEnabled: is the divider visible
    func navigationBar(backgroundMaterial: Material, foregroundColor: UIColor, isDividerEnabled: Bool = false) -> some View {
        self.modifier(NavigationBarModifier(backgroundColor: .clear, foregroundColor: foregroundColor, material: backgroundMaterial, isDividerEnabled: isDividerEnabled))
    }
}

