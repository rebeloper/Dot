//
//  Button+.swift
//  
//
//  Created by Alex Nagy on 03.10.2021.
//

import SwiftUI

public extension Button where Label == AnyView {
    
    /// Creates a button that displays a system symbol image.
    ///
    /// - Parameters:
    ///   - systemName: The name of the system symbol image.
    ///   - font: The font to use in this view; defaults to `nil`.
    ///   - width: Width of the button's `Label`
    ///   - height: Height of the button's `Label`
    ///   - isPushOutView: Is the `Label` a `Push Out View`
    ///   - action: The action to perform when the user triggers the button.
    init(systemName: String,
         font: Font? = nil,
         width: CGFloat? = nil,
         height: CGFloat? = nil,
         isPushOutView: Bool = false,
         action: @escaping () -> Void) {
        self.init(action: action,
                  label: {
            Image(systemName: systemName)
                .font(font)
                .frame(width: width, height: height)
                .isPushOutView(isPushOutView)
                .anyView()
        })
    }
}
