//
//  ToastViewModifier.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

public struct ToastViewModifier: ViewModifier {
    
    @ObservedObject public var toast: Toast
    
    public func body(content: Content) -> some View {
        ZStack {
            content.disabled(toast.config.shouldDisableContent ? toast.isPresented : false)
            ToastView($toast.isPresented, config: $toast.config)
        }
    }
}

