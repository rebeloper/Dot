//
//  AlertViewModifier.swift
//  Dot
//
//  Created by Alex Nagy on 09.08.2021.
//

import SwiftUI

public struct AlertViewModifier: ViewModifier {
    
    @ObservedObject public var alertsManager: AlertsManager
    
    public func body(content: Content) -> some View {
        content
            .alert(alertsManager.alertItem.title, isPresented: $alertsManager.isAlertPresented) {
                ForEach(alertsManager.alertItem.actions) { action in
                    Button(role: action.role, action: action.action) {
                        Text(action.title)
                    }
                }
            } message: {
                if alertsManager.alertItem.message != nil {
                    Text(alertsManager.alertItem.message!)
                } else {
                    EmptyView()
                }
            }
            .confirmationDialog(alertsManager.alertItem.title, isPresented: $alertsManager.isConfirmationDialogPresented, titleVisibility: alertsManager.alertItem.title == "" ? .hidden : .visible) {
                ForEach(alertsManager.alertItem.actions) { action in
                    Button(role: action.role, action: action.action) {
                        Text(action.title)
                    }
                }
            } message: {
                if alertsManager.alertItem.message != nil {
                    Text(alertsManager.alertItem.message!)
                } else {
                    EmptyView()
                }
            }

    }
}

public extension View {
    func uses(_ alertsManager: AlertsManager) -> some View {
        modifier(AlertViewModifier(alertsManager: alertsManager))
    }
}
