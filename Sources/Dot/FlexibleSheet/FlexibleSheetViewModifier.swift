//
//  FlexibleSheetViewModifier.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

struct FlexibleSheetViewModifier<SheetContent>: ViewModifier where SheetContent: View {
    
    var content: () -> FlexibleSheet<SheetContent>
    
    init(@ViewBuilder content: @escaping () -> FlexibleSheet<SheetContent>) {
        self.content = content
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
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
                                       disableDragToDismiss: Bool = false,
                                       disableTapBackgroundToDismiss: Bool = true,
                                       showsCloseButton: Bool = false,
                                       @ViewBuilder content: @escaping () -> T) -> some View {
        modifier(FlexibleSheetViewModifier(content: {
            FlexibleSheet(isPresented: isPresented, cornerRadius: cornerRadius, additionalOffset: additionalOffset, content: content)
                .height(height)
                .contentInsets(contentInsets)
                .backgroundColor(backgroundColor)
                .closeButtonColor(closeButtonColor)
                .disableDragToDismiss(disableDragToDismiss)
                .disableTapBackgroundToDismiss(disableTapBackgroundToDismiss)
                .showsCloseButton(showsCloseButton)
        }))
    }
}
