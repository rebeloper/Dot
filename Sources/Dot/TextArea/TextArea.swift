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
