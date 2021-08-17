//
//  SwipeableViewAction.swift
//  Dot
//
//  Created by Alex Nagy on 17.08.2021.
//

import SwiftUI

public struct SwipeableViewAction: Identifiable {
    
    public let id: UUID = UUID.init()
    let title: String
    let iconName: String
    let backgroundColor: Color
    let action: () -> ()?
    
    public init(title: String,
                iconName: String,
                backgroundColor: Color,
                action: @escaping () -> ()?) {
        self.title = title
        self.iconName = iconName
        self.backgroundColor = backgroundColor
        self.action = action
    }
}


