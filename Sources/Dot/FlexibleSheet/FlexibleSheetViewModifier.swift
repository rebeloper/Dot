//
//  FlexibleSheetViewModifier.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

public struct FlexibleSheetViewModifier: ViewModifier {
    
    @StateObject private var flexibleSheetManager = FlexibleSheetManager()
    
    public var config: FlexibleSheetConfig = FlexibleSheetConfig()
    public var containerConfig: FlexibleSheetContainerConfig = FlexibleSheetContainerConfig()
    @EnvironmentObject var flexibleSheetFullScreenState: FlexibleSheetFullScreenState
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .bottom){
            Color(.black)
            
            content
                .mask( RoundedRectangle(cornerRadius: flexibleSheetManager.isPresented ? containerConfig.animates ? containerConfig.cornerRadius : 0 : 0, style: containerConfig.cornerStyle) )
                .scaleEffect(flexibleSheetManager.isPresented ? containerConfig.animates ? containerConfig.scale : 1 : 1)
                .animation(containerConfig.animation, value: 1)
                .disabled(flexibleSheetManager.isPresented)
            
            containerConfig.coverColor.opacity(flexibleSheetManager.isPresented ? containerConfig.coverColorOpacity : 0)
            
            VStack(spacing: 0){
                flexibleSheetManager.sheet()
                    .background(Color.secondarySystemBackground)
                    .frame(width: UIScreen.main.bounds.width)
                    .layoutPriority(2)
            }
            .mask( RoundedRectangle(cornerRadius: config.cornerRadius, style: config.cornerStyle) )
            .layoutPriority(1)
            .padding(.top, /*(UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + */(config.swipeableUp ? (flexibleSheetFullScreenState.isActive ? 0 : config.topPadding) : config.topPadding))
            .frame(height: flexibleSheetManager.isPresented ? (config.swipeableUp ? (flexibleSheetFullScreenState.isActive ? UIScreen.main.bounds.height : nil) : nil) : 0, alignment: .top)
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
                            // left swipe
                        } else if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30 {
                            // right swipe
                        } else if value.translation.height < 0 && value.translation.width < 100 && value.translation.width > -100 {
                            // up swipe
                            if config.swipeableUp {
                                flexibleSheetFullScreenState.isActive = true
                            }
                        } else if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
                            // down swipe
                            if config.swipeableDown {
                                if flexibleSheetFullScreenState.isActive {
                                    flexibleSheetFullScreenState.isActive = false
                                } else {
                                    flexibleSheetManager.isPresented = false
                                }
                            }
                        } else {
                            // not left, right, up or down swipe
                        }
                    }
            )
            .animation(config.animates ? config.animation : nil, value: 1)
        }
        .edgesIgnoringSafeArea(.all)
        .environmentObject(flexibleSheetManager)
    }
}

