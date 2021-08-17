//
//  ShareSheetAction.swift
//  Dot
//
//  Created by Alex Nagy on 17.08.2021.
//

import SwiftUI

public struct ShareSheetAction: View {
    
    @State private var isPresented = false
    
    private var style: ShareSheetActionStyle
    private var shareSheetView: () -> ShareSheetView
    private var label: () -> AnyView
    
    /// Share Sheet Button
    /// - Parameters:
    ///   - style: the style of the action, defaults to `.button`
    ///   - shareSheetView: a ShareSheetView to be presented
    ///   - label: Label of the Share Sheet Button
    public init(style: ShareSheetActionStyle = .button, shareSheetView: @escaping () -> ShareSheetView,
                label: @escaping () -> AnyView) {
        self.style = style
        self.shareSheetView = shareSheetView
        self.label = label
    }
    
    public var body: some View {
        switch style {
        case .button:
            Button {
                isPresented = true
            } label: {
                label()
            }
            .sheet(isPresented: $isPresented) {
                shareSheetView()
            }
            
        case .view:
            label()
                .onTapGesture {
                    isPresented = true
                }
                .sheet(isPresented: $isPresented) {
                    shareSheetView()
                }
        }
    }
}

