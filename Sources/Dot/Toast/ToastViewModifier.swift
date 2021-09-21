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
            content
            ToastView($toast.isPresented, config: $toast.config)
        }
    }
}

