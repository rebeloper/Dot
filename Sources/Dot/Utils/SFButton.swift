//
//  SFButton.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

public struct SFButton: View {
    
    private let action: () -> ()
    private let name: String
    private let font: Font?
    
    /// A Button with an SFSymbol label
    /// - Parameters:
    ///   - action: action of the button
    ///   - name: name of the SFSymbol
    ///   - font: font of the SFSymbol
    public init(action: @escaping () -> (),
                name: String,
                font: Font? = nil) {
        self.action = action
        self.name = name
        self.font = font
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: name)
                .font(font)
        }
    }
}
