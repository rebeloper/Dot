//
//  FlexibleSheetViewModifier.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

struct FlexibleSheetViewModifier<SheetContent>: ViewModifier where SheetContent: View {
    
    @Binding var isPresented: Bool
    var content: () -> FlexibleSheet<SheetContent>
    
    init(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> FlexibleSheet<SheetContent>) {
        self._isPresented = isPresented
        self.content = content
    }
    
    func body(content: Content) -> some View {
        ZStack {
            if isPresented {
                Color.black.edgesIgnoringSafeArea(.all)
            }
            
            content
                .transition(.scale)
                .scaleEffect(isPresented ? 0.95 : 1.0)
                .clipShape(RoundedRectangle(cornerRadius: isPresented ? 15 : 0))
            
            self.content()
        }
    }
}

extension View {
    public func flexibleSheet<T: View>(isPresented: Binding<Bool>,
                                       height: FlexibleSheetHeight = .proportional(0.84),
                                       cornerRadius: CGFloat = 15,
                                       additionalOffset: CGFloat = 44,
                                       contentInsets: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0),
                                       backgroundColor: UIColor = .systemBackground,
                                       closeButtonColor: UIColor = .lightGray,
                                       outsideColor: UIColor = .label,
                                       outsideOpacity: CGFloat = 0.15,
                                       allowsDragToDismiss: Bool = false,
                                       allowsTapOutsideToDismiss: Bool = true,
                                       showsCloseButton: Bool = false,
                                       @ViewBuilder content: @escaping () -> T) -> some View {
        modifier(FlexibleSheetViewModifier(isPresented: isPresented, content: {
            FlexibleSheet(isPresented: isPresented, content: content)
                .height(height)
                .contentInsets(contentInsets)
                .backgroundColor(backgroundColor)
                .closeButtonColor(closeButtonColor)
                .outsideColor(outsideColor)
                .outsideOpacity(outsideOpacity)
                .allowsDragToDismiss(allowsDragToDismiss)
                .allowsTapOutsideToDismiss(allowsTapOutsideToDismiss)
                .showsCloseButton(showsCloseButton)
                .additionalOffset(additionalOffset)
                .cornerRadius(cornerRadius)
        }))
    }
}
