//
//  TextArea.swift
//  
//
//  Created by Alex Nagy on 23.05.2022.
//

import SwiftUI

/// `TextEditor` with dynamic height
public struct TextArea: View {
    
    public var title: String = ""
    @Binding public var text: String
    @State public var height : CGFloat = 20
    public var font: TextAreaFont = TextAreaFont(size: 17.5, weight: .regular, design: .default)
    public var foregroundColor: Color = Color(uiColor: .label)
    public var titleForegroundColor: Color = .secondary
    
    public var body: some View {
        
        ZStack(alignment: .leading) {
            HStack {
                Text(text)
                    .font(.system(size: font.size, weight: font.weight, design: font.design))
                    .foregroundColor(foregroundColor)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(GeometryReader {
                        Color.clear.preference(key: ViewHeightKey.self,
                                               value: $0.frame(in: .local).size.height)
                    })
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, font.size / 2)
            .overlay(
                TextEditor(text: $text)
                    .font(.system(size: font.size, weight: font.weight, design: font.design))
                    .foregroundColor(.clear)
                    .disableAutocorrection(true)
                    .padding(.horizontal, font.size / 8)
                    .padding(.top, font.size / 4)
                    .onAppear {
                        UITextView.appearance().backgroundColor = .clear
                        UITextView.appearance().showsVerticalScrollIndicator = false
                    }
            )
            .frame(height: max(20, height))
            
            Text(title)
                .font(.system(size: font.size, weight: font.weight, design: font.design))
                .foregroundColor(titleForegroundColor)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.horizontal, 8)
                .padding(.vertical, font.size / 2)
                .opacity(text.isEmpty ? 1 : 0)
                .allowsHitTesting(false)
                
        }.onPreferenceChange(ViewHeightKey.self) { height = $0 }
    }
    
}

public struct ViewHeightKey: PreferenceKey {
    public static var defaultValue: CGFloat { 0 }
    public static func reduce(value: inout Value, nextValue: () -> Value) {
        value = value + nextValue()
    }
}

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

public struct TextAreaFont {
    public let size: CGFloat
    public let weight: Font.Weight
    public let design: Font.Design
}
