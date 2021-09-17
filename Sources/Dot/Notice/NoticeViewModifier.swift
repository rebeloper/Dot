//
//  NoticeViewModifier.swift
//  Dot
//
//  Created by Alex Nagy on 09.08.2021.
//

import SwiftUI

public struct NoticeViewModifier: ViewModifier {
    
    @ObservedObject public var notice: Notice
    
    public func body(content: Content) -> some View {
        content
            .if(notice.item.type == .alert, transform: { content in
                content
                    .alert(notice.item.title, isPresented: $notice.isPresented) {
                        ForEach(notice.item.actions) { action in
                            Button(role: action.role, action: action.action) {
                                Text(action.title)
                            }
                        }
                        if !containsCancelAction(actions: notice.item.actions) {
                            Button(role: .cancel) { } label: {
                                Text("Cancel")
                            }
                        }
                    } message: {
                        if notice.item.message != nil {
                            Text(notice.item.message!)
                        } else {
                            EmptyView()
                        }
                    }
            })
                .if(notice.item.type == .confirmationDialog, transform: { content in
                    content
                        .confirmationDialog(notice.item.title, isPresented: $notice.isPresented, titleVisibility: notice.item.title == "" ? .hidden : .visible) {
                            ForEach(notice.item.actions) { action in
                                Button(role: action.role, action: action.action) {
                                    Text(action.title)
                                }
                            }
                        } message: {
                            if notice.item.message != nil {
                                Text(notice.item.message!)
                            } else {
                                EmptyView()
                            }
                        }
                })
    }
    
    private func containsCancelAction(actions: [NoticeAction]) -> Bool {
        var contains = false
        actions.forEach { action in
            if action.role == .cancel {
                contains = true
            }
        }
        return contains
    }
}

public extension View {
    func uses(_ notice: Notice) -> some View {
        modifier(NoticeViewModifier(notice: notice))
    }
}
