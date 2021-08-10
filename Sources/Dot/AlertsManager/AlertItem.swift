//
//  AlertItem.swift
//  Dot
//
//  Created by Alex Nagy on 09.08.2021.
//

import SwiftUI

public struct AlertItem {
    public var title: String
    public var message: String?
    public var actions: [AlertAction]
    
    public init(title: String? = nil,
         message: String? = nil,
         actions: [AlertAction] = []) {
        self.title = title != nil ? title! : ""
        self.message = message
        self.actions = actions
    }
}
