//
//  AdaptiveSheetViewModifier.swift
//  Dot
//
//  Created by Alex Nagy on 16.08.2021.
//

import SwiftUI

public struct AdaptiveSheetViewModifier<T: View>: ViewModifier {
    
    let sheetContent: T
    @Binding var isPresented: Bool
    let adaptiveSheetOptions: AdaptiveSheetOptions
    
    public init(isPresented: Binding<Bool>,
                adaptiveSheetOptions: AdaptiveSheetOptions,
                @ViewBuilder content: @escaping () -> T) {
        self.sheetContent = content()
        self.adaptiveSheetOptions = adaptiveSheetOptions
        self._isPresented = isPresented
    }
    
    public func body(content: Content) -> some View {
        ZStack{
            content
            AdaptiveSheetViewControllerRepresentable(isPresented: $isPresented,
                                                     adaptiveSheetOptions: adaptiveSheetOptions,
                                                     content: {sheetContent}).frame(width: 0, height: 0)
        }
    }
}

public extension View {
    func adaptiveSheet<T: View>(isPresented: Binding<Bool>,
                                adaptiveSheetOptions: AdaptiveSheetOptions = AdaptiveSheetOptions(),
                                @ViewBuilder content: @escaping () -> T)-> some View {
        modifier(AdaptiveSheetViewModifier(isPresented: isPresented,
                                           adaptiveSheetOptions : adaptiveSheetOptions,
                                           content: content))
    }
}

