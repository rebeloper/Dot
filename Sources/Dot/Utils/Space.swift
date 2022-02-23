//
//  SwiftUIView.swift
//  
//
//  Created by Alex Nagy on 21.02.2022.
//

import SwiftUI

public struct Space: View {
    
    private var width: CGFloat?
    private var height: CGFloat?
    
    /// ``Spacer`` with ``minLength`` of ``0`` and width & height
    public init(width: CGFloat,
                height: CGFloat) {
        self.width = width
        self.height = height
    }
    
    /// ``Spacer`` with ``minLength`` of ``0`` and a width
    public init(width: CGFloat) {
        self.width = width
        self.height = nil
    }
    
    /// ``Spacer`` with ``minLength`` of ``0`` and a height
    public init(height: CGFloat) {
        self.width = nil
        self.height = height
    }
    
    /// ``Spacer`` with ``minLength`` of ``0``
    public init() {
        self.width = nil
        self.height = nil
    }
    
    public var body: some View {
        if width == nil, height == nil {
            Spacer(minLength: 0)
        } else {
            Spacer(minLength: 0).frame(width: width, height: height)
        }
    }
}
