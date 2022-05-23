//
//  TextArea+View.swift
//  
//
//  Created by Alex Nagy on 23.05.2022.
//

import SwiftUI

public extension View {
    
    @ViewBuilder
    /// Style for the `TextArea`
    /// - Parameter style: style type
    func textAreaStyle(_ style: TextAreaStyle) -> some View {
        switch style {
        case .plain:
            self.padding(.vertical, 4)
                .background(Color(uiColor: .secondarySystemFill))
        case .plainWith(let verticalPadding, let backgroundColor):
            self.padding(.vertical, verticalPadding)
                .background(backgroundColor)
        case .rounded:
            self.padding(.vertical, 4)
                .background(Color(uiColor: .secondarySystemFill))
                .cornerRadius(10)
        case .roundedWith(let verticalPadding, let backgroundColor, let cornerRadius):
            self.padding(.vertical, verticalPadding)
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
        case .roundedBorder:
            self.padding(.vertical, 4)
                .background(Color(uiColor: .systemBackground))
                .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(uiColor: .secondarySystemFill), style: StrokeStyle(lineWidth: 1))
            )
        case .roundedBorderWith(let verticalPadding, let backgroundColor, let strokeColor, let cornerRadius, let lineWidth):
            self.padding(.vertical, verticalPadding)
                .background(backgroundColor)
                .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(strokeColor, style: StrokeStyle(lineWidth: lineWidth))
            )
        case .roundedDashBorder:
            self.padding(.vertical, 4)
                .background(Color(uiColor: .systemBackground))
                .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(uiColor: .secondarySystemFill), style: StrokeStyle(lineWidth: 1, dash: [8]))
            )
        case .roundedDashBorderWith(let verticalPadding, let backgroundColor, let strokeColor, let cornerRadius, let lineWidth, let dash):
            self.padding(.vertical, verticalPadding)
                .background(backgroundColor)
                .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(strokeColor, style: StrokeStyle(lineWidth: lineWidth, dash: dash))
            )
        }
    }
}
