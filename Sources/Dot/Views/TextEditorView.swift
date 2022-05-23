//
//  TextEditorView.swift
//  
//
//  Created by Alex Nagy on 23.05.2022.
//

import SwiftUI

/// `TextEditor` with dynamic height
public struct TextEditorView: View {
    
    public var title: String = ""
    @Binding public  var text: String
    @State public var height : CGFloat = 20
    public var font: Font = .system(.body)
    
    public var body: some View {
        
        ZStack(alignment: .leading) {
            Text(text)
                .font(font)
                .foregroundColor(.clear)
                .padding(.top, 14)
                .padding(.horizontal, 14)
                .padding(.bottom, text.isEmpty ? 6.5 : 0)
                .background(GeometryReader {
                    Color.clear.preference(key: ViewHeightKey.self,
                                           value: $0.frame(in: .local).size.height)
                })

            TextEditor(text: $text)
                .font(font)
                .frame(height: max(20, height))
                .onAppear {
                    UITextView.appearance().backgroundColor = .clear
                }
                .padding(.top, 5)
                .padding(.horizontal, 1)
            
            Text(title)
                .foregroundColor(.secondary)
                .fixedSize(horizontal: true, vertical: false)
                .padding(.horizontal, 6)
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

public enum TextEditorViewStyle {
    case plain
    case rounded
    case roundedBorder
    case roundedDashBorder
}


public extension View {
    
    @ViewBuilder
    /// Style for the `TextEditorView`
    /// - Parameter style: style type
    func textEditorViewStyle(_ style: TextEditorViewStyle) -> some View {
        switch style {
        case .plain:
            self.background(Color(uiColor: .secondarySystemFill))
        case .rounded:
            self.background(Color(uiColor: .secondarySystemFill))
                .cornerRadius(10)
        case .roundedBorder:
            self.background(Color(uiColor: .systemBackground))
                .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(uiColor: .secondarySystemFill), style: StrokeStyle(lineWidth: 1))
            )
        case .roundedDashBorder:
            self.background(Color(uiColor: .systemBackground))
                .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(uiColor: .secondarySystemFill), style: StrokeStyle(lineWidth: 1, dash: [8]))
            )
        }
    }
}

