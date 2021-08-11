//
//  NoticeAction.swift
//  Dot
//
//  Created by Alex Nagy on 09.08.2021.
//

import SwiftUI

public struct NoticeAction: Identifiable {
    public var id = UUID().uuidString
    public var role: ButtonRole?
    public var title: String
    public var action: () -> Void
    
    public init(role: ButtonRole? = nil,
         title: String,
         action: @escaping () -> Void) {
        self.role = role
        self.title = title
        self.action = action
    }
}
