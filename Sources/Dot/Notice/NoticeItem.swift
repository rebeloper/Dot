//
//  NoticeItem.swift
//  Dot
//
//  Created by Alex Nagy on 09.08.2021.
//

import SwiftUI

public struct NoticeItem {
    public var type: NoticeType
    public var title: String
    public var message: String?
    public var actions: [NoticeAction]
    
    public init(type: NoticeType = .none,
                title: String? = nil,
                message: String? = nil,
                actions: [NoticeAction] = []) {
        self.type = type
        self.title = title != nil ? title! : (type == .alert && message = nil) ? "Alert" : ""
        self.message = message
        self.actions = actions
    }
}
