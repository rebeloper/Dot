//
//  AlertsManager.swift
//  Dot
//
//  Created by Alex Nagy on 09.08.2021.
//

import SwiftUI

public class AlertsManager: ObservableObject {
    
    public init() {}
    
    @Published public var isPresented = false
    @Published public var alertItem = AlertItem()
    
    public func show(_ type: AlertType = .alert, title: String? = nil, message: String? = nil, actions: [AlertAction] = []) {
        alertItem = AlertItem(type: type, title: title, message: message, actions: actions)
        isPresented.toggle()
    }
}
