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
    
    public func show(type: AlertType = .alert, title: String? = nil, message: String? = nil, actions: [AlertAction] = []) {
        alertItem = AlertItem(title: title, message: message, actions: actions)
        switch type {
        case .alert:
            isAlertPresented.toggle()
        case .confirmationDialog:
            isConfirmationDialogPresented.toggle()
        }
    }
}
