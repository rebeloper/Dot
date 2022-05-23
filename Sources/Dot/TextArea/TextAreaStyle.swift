//
//  TextAreaStyle.swift
//  
//
//  Created by Alex Nagy on 23.05.2022.
//

import SwiftUI

public enum TextAreaStyle {
    case plain
    case plainWith(verticalPadding: CGFloat, backgroundColor: Color)
    case rounded
    case roundedWith(verticalPadding: CGFloat, backgroundColor: Color, cornerRadius: CGFloat)
    case roundedBorder
    case roundedBorderWith(verticalPadding: CGFloat, backgroundColor: Color, strokeColor: Color, cornerRadius: CGFloat, lineWidth: CGFloat)
    case roundedDashBorder
    case roundedDashBorderWith(verticalPadding: CGFloat, backgroundColor: Color, strokeColor: Color, cornerRadius: CGFloat, lineWidth: CGFloat, dash: [CGFloat])
}
