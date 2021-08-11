//
//  Notice.swift
//  Dot
//
//  Created by Alex Nagy on 09.08.2021.
//

import SwiftUI

public class Notice: ObservableObject {
    
    public init() {}
    
    @Published public var isPresented = false
    @Published public var item = NoticeItem()
    
    public func present(_ type: NoticeType = .alert, title: String? = nil, message: String? = nil, actions: [NoticeAction] = []) {
        item = NoticeItem(type: type, title: title, message: message, actions: actions)
        isPresented.toggle()
    }
}
