//
//  Color+.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

public extension Color {
    
    /// Color from HEX
    /// - Parameter hex: HEX
    init(hex: String) {
        let scanner = Scanner(string: hex)
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: Double(r) / 0xff, green: Double(g) / 0xff, blue: Double(b) / 0xff)
    }
    
}

import Foundation
import UIKit
/// Color definitions of the UIColor constant colors.
public extension Color {
    // Adaptable colors
    static let systemRed = Color(UIColor.systemRed)
    static let systemGreen = Color(UIColor.systemGreen)
    static let systemBlue = Color(UIColor.systemBlue)
    static let systemOrange = Color(UIColor.systemOrange)
    static let systemYellow = Color(UIColor.systemYellow)
    static let systemPink = Color(UIColor.systemPink)
    static let systemPurple = Color(UIColor.systemPurple)
    static let systemTeal = Color(UIColor.systemTeal)
    static let systemIndigo = Color(UIColor.systemIndigo)
    static let systemBrown = Color(UIColor.systemBrown)
    static let systemMint = Color(UIColor.systemMint)
    static let systemCyan = Color(UIColor.systemCyan)
    
    // Adaptable grayscales
    static let systemGray = Color(UIColor.systemGray)
    static let systemGray2 = Color(UIColor.systemGray2)
    static let systemGray3 = Color(UIColor.systemGray3)
    static let systemGray4 = Color(UIColor.systemGray4)
    static let systemGray5 = Color(UIColor.systemGray5)
    static let systemGray6 = Color(UIColor.systemGray6)
    
    // Adaptable black and white
    static let systemBlack = Color(UIColor.label)
    static let systemWhite = Color(UIColor.systemBackground)
    
    // Adaptable text colors
    static let label = Color(UIColor.label)
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    static let tertiaryLabel = Color(UIColor.tertiaryLabel)
    static let quaternaryLabel = Color(UIColor.quaternaryLabel)
    static let link = Color(UIColor.link)
    static let placeholderText = Color(UIColor.placeholderText)
    // Adaptable separators
    static let separator = Color(UIColor.separator)
    static let opaqueSeparator = Color(UIColor.opaqueSeparator)
    // Adaptable backgrounds
    static let systemBackground = Color(UIColor.systemBackground)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)
    // Adaptable grouped backgrounds
    static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
    static let secondarySystemGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
    static let tertiarySystemGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)
    // Adaptable system fills
    static let systemFill = Color(UIColor.systemFill)
    static let secondarySystemFill = Color(UIColor.secondarySystemFill)
    static let tertiarySystemFill = Color(UIColor.tertiarySystemFill)
    static let quaternarySystemFill = Color(UIColor.quaternarySystemFill)
    
    static let lightText = Color(UIColor.lightText)
    static let darkText = Color(UIColor.darkText)
    
    // "Fixed" colors
    static let fixedBlack = Color(UIColor.black)
    static let fixedDarkGray = Color(UIColor.darkGray)
    static let fixedLightGray = Color(UIColor.lightGray)
    static let fixedWhite = Color(UIColor.white)
    static let fixedGray = Color(UIColor.gray)
    static let fixedRed = Color(UIColor.red)
    static let fixedGreen = Color(UIColor.green)
    static let fixedBlue = Color(UIColor.blue)
    static let fixedCyan = Color(UIColor.cyan)
    static let fixedYellow = Color(UIColor.yellow)
    static let fixedMagenta = Color(UIColor.magenta)
    static let fixedOrange = Color(UIColor.orange)
    static let fixedPurple = Color(UIColor.purple)
    static let fixedBrown = Color(UIColor.brown)
    static let fixedClear = Color(UIColor.clear)
}

public extension Color {
    func uiColor() -> UIColor {
        UIColor(self)
    }
}

public extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
    
    static var systemRandom: Color {
        return [
            .systemRed,
            .systemGreen,
            .systemBlue,
            .systemOrange,
            .systemYellow,
            .systemPink,
            .systemPurple,
            .systemTeal,
            .systemIndigo,
            .systemBrown,
            .systemMint,
            .systemCyan,
            .systemGray,
            .systemGray2,
            .systemGray3,
            .systemGray4,
            .systemGray5,
            .systemGray6
        ].randomElement() ?? Color.black
    }
}
