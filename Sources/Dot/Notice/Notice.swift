//
//  Notice.swift
//  Dot
//
//  Created by Alex Nagy on 09.08.2021.
//

import SwiftUI

public class Notice: ObservableObject {
    
    public init() {}
    
    @Published private var isPreviousPresented = false
    @Published public var isPresented = false
    @Published public var item = NoticeItem()
    
    public func present(_ type: NoticeType = .alert, title: String? = nil, message: String? = nil, actions: [NoticeAction] = []) {
        if isPreviousPresented {
            isPresented = false
        }
        item = NoticeItem(type: type, title: title, message: message, actions: actions)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.isPresented = true
            self.isPreviousPresented = true
        }
    }
    
    public func present(alert type: NoticeDefaultType, message: String? = nil, actions: [NoticeAction] = [NoticeAction(role: .cancel, title: "Ok", action: { })]) {
        var title = ""
        switch type {
        case .error:
            title = "Error"
        case .success:
            title = "Success"
        case .warning:
            title = "Warning"
        case .info:
            title = "Info"
        }
        present(.alert, title: title, message: message, actions: actions)
    }
    
    public func present(confirmationDialog type: NoticeDefaultType, message: String? = nil, actions: [NoticeAction] = [.cancel(title: "Ok")]) {
        var title = ""
        switch type {
        case .error:
            title = "Error"
        case .success:
            title = "Success"
        case .warning:
            title = "Warning"
        case .info:
            title = "Info"
        }
        present(.confirmationDialog, title: title, message: message, actions: actions)
    }
    
}
