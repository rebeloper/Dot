//
//  ScrollViewOffsetPreferenceKey.swift
//  Dot
//
//  Created by Alex Nagy on 13.09.2021.
//

import SwiftUI

public struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    public static var defaultValue: CGFloat = .zero
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {}
}
