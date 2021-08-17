//
//  ColorSchemeKitColorScheme.swift
//  Dot
//
//  Created by Alex Nagy on 17.08.2021.
//

import SwiftUI

public enum ColorSchemeKitColorScheme {
    case initial, system, light, dark
    init(code:Int) {
        if code == 0 {
            self = .system
        } else if code == 1 {
            self = .light
        } else {
            self = .dark
        }
    }
    
    public func systemColorScheme() -> ColorScheme {
        if self == .system || self == .initial {
            return ColorSchemeManager.deviceColorScheme
        } else if self == .light {
            return .light
        } else {
            return .dark
        }
    }
}

