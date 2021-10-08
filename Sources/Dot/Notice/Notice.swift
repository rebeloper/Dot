//
//  Notice.swift
//  
//
//  Created by Alex Nagy on 30.09.2021.
//

import UIKit

public typealias NoticeController = UIAlertController
public typealias NoticeControllerStyle = NoticeController.Style
public typealias NoticeButton = UIAlertAction

/// `alert` / `confirmationDialog` presenter
public struct Notice {
    
    /// Presents a notice with an `alert` / `confirmationDialog` style and optional `title`, `message`, `buttons`, animation flag and `completion`
    /// - Parameters:
    ///   - style: style of the notice
    ///   - title: title of the notice; default is `nil`
    ///   - message: message of the notice; default is `nil`
    ///   - buttons: buttons of the notice; default is none set, but addig a `cancel` button with an `OK` title instead
    ///   - flag: animation flag; default is `true`
    ///   - completion: completion callback
    public static func present(_ style: NoticeStyle, title: String? = nil, message: String? = nil, buttons: [NoticeButton] = [], animated flag: Bool = true, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: getNoticeControllerStyle(for: style))
        if buttons.isEmpty {
            alert.addAction(NoticeButton(.ok))
        } else {
            buttons.forEach { button in
                alert.addAction(button)
            }
        }
        alert.presentNotice(animated: flag, completion: completion)
    }
    
    /// Presents a notice with an `alert` / `confirmationDialog` style and optional `title`, `message`, `buttons`, animation flag and `completion`
    /// - Parameters:
    ///   - style: style of the notice
    ///   - title: title of the notice; default is `nil`
    ///   - message: message of the notice; default is `nil`
    ///   - buttons: buttons of the notice; default is none set, but addig a `cancel` button with an `OK` title instead
    public static func present(_ style: NoticeStyle, title: String? = nil, message: String? = nil, buttons: [NoticeButton] = []) {
        present(style, title: title, message: message, buttons: buttons, animated: true, completion: nil)
    }
    
    /// Presents a notice `type` with a `message` and optional an `alert` / `confirmationDialog` style (default is `alert`) and `buttons`. The `title` of the notice is definded by the `type`
    /// - Parameters:
    ///   - type: type of the notice
    ///   - style: style of the notice; default is `alert`
    ///   - message: message of the notice
    ///   - buttons: buttons of the notice; default is none set, but addig a `cancel` button with an `OK` title instead
    public static func present(_ type: NoticeType, _ style: NoticeStyle = .alert, message: String, buttons: [NoticeButton] = []) {
        present(style, title: getNoticeTitle(for: type), message: message, buttons: buttons)
    }
    
    /// Presents a notice `type` with an `alert` / `confirmationDialog` style, `message`. The `title` of the notice is definded by the `type`. The notice has one `cancel` button with an `OK` title
    /// - Parameters:
    ///   - type: type of the notice
    ///   - style: style of the notice
    ///   - message: message of the notice
    public static func present(_ type: NoticeType, _ style: NoticeStyle, message: String) {
        present(type, style, message: message, buttons: [])
    }
    
    private static func getNoticeTitle(for type: NoticeType) -> String {
        switch type {
        case .error:
            return "Error"
        case .success:
            return "Success"
        case .warning:
            return "Warning"
        case .info:
            return "Info"
        }
    }
    
    private static func getNoticeControllerStyle(for style: NoticeStyle) -> NoticeControllerStyle {
        switch style {
        case .confirmationDialog:
            return .actionSheet
        case .alert:
            return .alert
        }
    }
}

public extension NoticeButton {
    /// Create and return a notice button with the specified `title`, `action` and optional `style` (default is `default`)
    /// - Parameters:
    ///   - title: title of the notice button
    ///   - style: style of the notice button, default is `default`
    ///   - action: action of the notice button
    convenience init(title: String, style: Style = .default, action: (() -> ())?) {
        self.init(title: title, style: style) { _ in
            action?()
        }
    }
    
    /// Create and return a notice button with the specified `title` from the `type` and optional `style` (default is `cancel`) and `action`
    /// - Parameters:
    ///   - type: type of the notice button
    ///   - style: style of the notice button, default is `cancel`
    ///   - action: action of the notice button
    convenience init(_ type: NoticeButtonType, style: Style = .cancel, action: (() -> ())? = nil) {
        var title = ""
        switch type {
        case .ok:
            title = "OK"
        case .cancel:
            title = "Cancel"
        case .agree:
            title = "Agree"
        case .later:
            title = "Later"
        case .remindMeLater:
            title = "Remind me later"
        case .skip:
            title = "Skip"
        case .dontAskAgain:
            title = "Don't ask again"
        case .dismiss:
            title = "Dismiss"
        case .forward:
            title = "Forward"
        case .back:
            title = "Back"
        case .previous:
            title = "Previous"
        case .next:
            title = "Next"
        case .yes:
            title = "Yes"
        case .no:
            title = "No"
        case .confirm:
            title = "Confirm"
        case .deny:
            title = "Deny"
        case .open:
            title = "Open"
        case .close:
            title = "Close"
        }
        self.init(title: title, style: style) { _ in
            action?()
        }
    }
}

public extension NoticeController {
    
    /// Presents a Notice on the root view controller with optional animation flag and completion
    /// - Parameters:
    ///   - flag: animation flag; default is `true`
    ///   - completion: completion callback
    func presentNotice(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        UIApplication.rootViewController()?.present(self, animated: flag, completion: completion)
    }
    
    /// Dismisses a Notice on the root view controller with optional animation flag and completion
    /// - Parameters:
    ///   - flag: animation flag; default is `true`
    ///   - completion: completion callback
    func dismissNotice(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        UIApplication.rootViewController()?.dismiss(animated: flag, completion: completion)
    }
}

public enum NoticeType {
    case error, success, warning, info
}

public enum NoticeStyle {
    case confirmationDialog, alert
}

public enum NoticeButtonType {
    case ok, cancel, agree, later, remindMeLater, skip, dontAskAgain, dismiss, forward, back, previous, next, yes, no, confirm, deny, open, close
}
