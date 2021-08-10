//
//  ProgressHUDViewModifier.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

public struct ProgressHUDViewModifier: ViewModifier {
    
    @ObservedObject public var progressHUDManager: ProgressHUDManager
    
    public func body(content: Content) -> some View {
        ZStack {
            content.disabled(progressHUDManager.config.shouldDisableContent ? progressHUDManager.isPresented : false)
            ProgressHUD($progressHUDManager.isPresented, config: progressHUDManager.config)
        }
    }
}

