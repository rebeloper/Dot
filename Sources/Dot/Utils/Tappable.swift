//
//  Tappable.swift
//  
//
//  Created by Alex Nagy on 03.10.2021.
//

import SwiftUI

public struct Tappable<Label> : View where Label : View {
    
    private let count: Int
    private let cornerRadius: CGFloat
    private let style: RoundedCornerStyle
    private let action: () -> Void
    private let label: () -> Label
    
    /// Creates a tappable and clipped view that displays a custom label.
    /// - Parameters:
    ///   - count: The number of taps or clicks required to trigger the action closure provided in `action`. Defaults to `1`
    ///   - cornerRadius: corner radius. Default is 0
    ///   - style: rounded corner style. Default is .circular
    ///   - action: The action to perform
    ///   - label: A view that describes the purpose of the tappable's `action`.
    public init(count: Int = 1,
         cornerRadius: CGFloat = 0,
         style: RoundedCornerStyle = .circular,
         action: @escaping () -> Void,
         @ViewBuilder label: @escaping () -> Label) {
        self.count = count
        self.cornerRadius = cornerRadius
        self.style = style
        self.action = action
        self.label = label
    }
    
    public var body: some View {
        label().onClippedTapGesture(count: count, cornerRadius: cornerRadius, style: style, perform: action)
    }
}
