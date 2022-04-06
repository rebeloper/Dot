//
//  PreferenceKeys.swift
//  
//
//  Created by Alex Nagy on 06.04.2022.
//

import SwiftUI

public extension View {
    
    /// Reads the size of the View
    /// - Parameter onChange: callback with the View size
    /// - Returns: a View
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

private struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

