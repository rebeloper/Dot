//
//  Button+.swift
//  
//
//  Created by Alex Nagy on 28.09.2021.
//

import SwiftUI

public extension Button {
    
    /// Creates a button with an asynchronous task that displays a custom label.
    ///
    /// - Parameters:
    ///   - task: The asynchronous task to perform when the user triggers the button.
    ///   - label: A view that describes the purpose of the button's `task`.
    init(task: @escaping () async throws -> Void, @ViewBuilder taskLabel: () -> Label) {
        self.init {
            Task {
                task
            }
        } label: {
            taskLabel()
        }
    }
    
    /// Creates a button with an asynchronous task and with a specified role that displays a custom label.
    ///
    /// - Parameters:
    ///   - role: An optional semantic role that describes the button. A value of
    ///     `nil` means that the button doesn't have an assigned role.
    ///   - task: The asynchronous task to perform when the user triggers the button.
    ///   - label: A view that describes the purpose of the button's `task`.
    init(role: ButtonRole?, task: @escaping () async throws -> Void, @ViewBuilder taskLabel: () -> Label) {
        self.init(role: role) {
            Task {
                task
            }
        } label: {
            taskLabel()
        }
    }
    
}

public extension Button where Label == Text {
    
    /// Creates a button with an asynchronous task that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - taskTitleKey: The key for the button's localized title, that describes
    ///     the purpose of the button's `task`.
    ///   - task: The action to perform when the user triggers the button.
    init(taskTitleKey: LocalizedStringKey, task: @escaping () async throws -> Void) {
        self.init(taskTitleKey) {
            Task {
                task
            }
        }
    }
    
    /// Creates a button with an asynchronous task and with a specified role that generates its label from a localized string key.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - taskTitleKey: The key for the button's localized title, that describes
    ///     the purpose of the button's `task`.
    ///   - role: An optional semantic role that describes the button. A value of
    ///     `nil` means that the button doesn't have an assigned role.
    ///   - task: The action to perform when the user triggers the button.
    init(taskTitleKey: LocalizedStringKey, role: ButtonRole?, task: @escaping () async throws -> Void) {
        self.init(taskTitleKey, role: role) {
            Task {
                task
            }
        }
    }
    
    /// Creates a button with an asynchronous task that generates its label from a string.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// - Parameters:
    ///   - taskTitle: A string that describes the purpose of the button's `task`.
    ///   - task: The action to perform when the user triggers the button.
    init<S>(taskTitle: S, task: @escaping () async throws -> Void) where S : StringProtocol {
        self.init(taskTitle) {
            Task {
                task
            }
        }
    }
    
    /// Creates a button with an asynchronous task and with a specified role that generates its label from a string.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)-9d1g4``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// - Parameters:
    ///   - taskTitle: A string that describes the purpose of the button's `task`.
    ///   - role: An optional semantic role that describes the button. A value of
    ///     `nil` means that the button doesn't have an assigned role.
    ///   - task: The action to perform when the user triggers the button.
    init<S>(taskTitle: S, role: ButtonRole?, task: @escaping () async throws -> Void) where S : StringProtocol {
        self.init(taskTitle, role: role) {
            Task {
                task
            }
        }
    }
}
