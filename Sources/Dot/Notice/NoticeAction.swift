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
                action: @escaping () -> Void = {}) {
        self.role = role
        self.title = title
        self.action = action
    }
}

public extension NoticeAction {
    static func regular(title: String, action: @escaping () -> Void = {}) -> NoticeAction {
        NoticeAction(role: .none, title: title, action: action)
    }
    
    static func destructive(title: String, action: @escaping () -> Void = {}) -> NoticeAction {
        NoticeAction(role: .destructive, title: title, action: action)
    }
    
    static func cancel(title: String = "Cancel", action: @escaping () -> Void = {}) -> NoticeAction {
        NoticeAction(role: .cancel, title: title, action: action)
    }
}
