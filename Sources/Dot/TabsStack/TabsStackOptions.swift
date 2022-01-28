//
//  TabsStackOptions.swift
//  
//
//  Created by Alex Nagy on 09.12.2021.
//

import SwiftUI

public struct TabsStackOptions {
    
    public var initialSelectedTabIndex: Int
    public var selectedColor: Color
    public var unselectedColor: Color
    public var height: CGFloat
    public var showsDivider: Bool
    public var edgeInsets: EdgeInsets
    public var isTabChangeAnimated: Bool
    
    public init(initialSelectedTabIndex: Int = 0,
                selectedColor: Color = .accentColor,
                unselectedColor: Color = .gray,
                height: CGFloat = 60,
                showsDivider: Bool = true,
                edgeInsets: EdgeInsets = .init(.zero),
                isTabChangeAnimated: Bool = false) {
        self.initialSelectedTabIndex = initialSelectedTabIndex
        self.selectedColor = selectedColor
        self.unselectedColor = unselectedColor
        self.height = height
        self.showsDivider = showsDivider
        self.edgeInsets = edgeInsets
        self.isTabChangeAnimated = isTabChangeAnimated
    }
}

