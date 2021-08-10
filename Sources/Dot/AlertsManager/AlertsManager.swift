//
//  AlertsManager.swift
//  Dot
//
//  Created by Alex Nagy on 09.08.2021.
//

import SwiftUI

public class AlertsManager: ObservableObject {
    
    public init() {}
    
    @Published public var isAlertPresented = false
    @Published public var isConfirmationDialogPresented = false
    @Published public var alertItem = AlertItem()
    
    public func show(_ type: AlertType, title: String? = nil, message: String? = nil, actions: [AlertAction] = []) {
        alertItem = AlertItem(title: title, message: message, actions: actions)
        switch type {
        case .alert:
            isAlertPresented = true
            isConfirmationDialogPresented = false
        case .confirmationDialog:
            isAlertPresented = false
            isConfirmationDialogPresented = true
        }
    }
}
