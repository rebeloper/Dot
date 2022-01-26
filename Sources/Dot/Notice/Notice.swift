//
//  Notice.swift
//
//
//  Created by Alex Nagy on 30.09.2021.
//

import UIKit

public typealias NoticeController = UIAlertController
public typealias NoticeOptions = UIAlertController
public typealias NoticeControllerStyle = NoticeController.Style
public typealias NoticeButton = UIAlertAction

public var NoticeTextFields: [UITextField] = []

/// `alert` / `confirmationDialog` presenter
public struct Notice {
    
    /// Presents a notice with an `alert` / `confirmationDialog` style and optional `title`, `message`, `buttons`, animation flag and `completion`
    /// - Parameters:
    ///   - style: style of the notice
    ///   - title: title of the notice; default is `nil`
    ///   - message: message of the notice; default is `nil`
    ///   - buttons: buttons of the notice; default is none set, but addig a `default` button with an `OK` title instead
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
    ///   - buttons: buttons of the notice; default is none set, but addig a `default` button with an `OK` title instead
    public static func present(_ style: NoticeStyle, title: String? = nil, message: String? = nil, buttons: [NoticeButton] = []) {
        present(style, title: title, message: message, buttons: buttons, animated: true, completion: nil)
    }
    
    /// Presents a notice `type` with a `message` and optional an `alert` / `confirmationDialog` style (default is `alert`) and `buttons`. The `title` of the notice is definded by the `type`
    /// - Parameters:
    ///   - type: type of the notice
    ///   - style: style of the notice; default is `alert`
    ///   - message: message of the notice
    ///   - buttons: buttons of the notice; default is none set, but addig a `default` button with an `OK` title instead
    public static func present(_ type: NoticeType, _ style: NoticeStyle = .alert, message: String, buttons: [NoticeButton] = []) {
        present(style, title: getNoticeTitle(for: type), message: message, buttons: buttons)
    }
    
    /// Presents a notice `type` with an `alert` / `confirmationDialog` style, `message`. The `title` of the notice is definded by the `type`. The notice has one `default` button with an `OK` title
    /// - Parameters:
    ///   - type: type of the notice
    ///   - style: style of the notice
    ///   - message: message of the notice
    public static func present(_ type: NoticeType, _ style: NoticeStyle, message: String) {
        present(type, style, message: message, buttons: [])
    }
    
    /// Presents an alert notice that can have text fields (Confiramtion dialogs cannot have text fields)
    ///
    /// Example
    /// ```
    /// @State private var name = ""
    /// @State private var email = ""
    /// @State private var password = ""
    /// @State private var passwordCheck = ""
    /// ```
    /// ```
    /// let noticeOptions = NoticeOptions(NoticeOptionsValue(title: "Sign in"))
    ///
    /// var textFields: [NoticeTextField] = []
    /// textFields.append(NoticeTextField(title: "Name", autoCapitalizationType: .words))
    /// textFields.append(NoticeTextField(title: "Email", autoCapitalizationType: .none, keyboardType: .emailAddress))
    /// textFields.append(NoticeTextField(title: "Password", isSecure: true))
    /// textFields.append(NoticeTextField(title: "Re-enter Password", isSecure: true))
    ///
    /// var buttons: [NoticeButton] = []
    /// buttons.append(NoticeButton(title: "Submit", action: {
    ///      if noticeOptions.textFields?[2].text == noticeOptions.textFields?[3].text {
    ///          name = noticeOptions.textFields?[0].text ?? ""
    ///          email = noticeOptions.textFields?[1].text ?? ""
    ///          password = noticeOptions.textFields?[2].text ?? ""
    ///          passwordCheck = noticeOptions.textFields?[3].text ?? ""
    ///        }
    /// }))
    /// buttons.append(NoticeButton(.cancel, style: .cancel))
    ///
    /// Notice.present(noticeOptions, textFields: textFields, buttons: buttons)
    /// ```
    /// - Parameters:
    ///   - noticeOptions: optional title and message of the notice
    ///   - textFields: array of text fields
    ///   - buttons: buttons of the notice; default is none set, but addig a `default` button with an `OK` title instead
    ///   - flag: animation flag; default is `true`
    ///   - completion: completion callback
    public static func present(_ noticeOptions: NoticeOptions, textFields: [NoticeTextField], buttons: [NoticeButton] = [], animated flag: Bool = true, completion: (() -> Void)? = nil) {
        if buttons.isEmpty {
            noticeOptions.addAction(NoticeButton(.ok))
        } else {
            buttons.forEach { button in
                noticeOptions.addAction(button)
            }
        }
        if noticeOptions.preferredStyle == .alert {
            textFields.forEach { noticeTextField in
                noticeOptions.addTextField { uiTextField in
                    uiTextField.placeholder = noticeTextField.title
                    uiTextField.isSecureTextEntry = noticeTextField.isSecure
                    uiTextField.autocapitalizationType = noticeTextField.autoCapitalizationType
                    uiTextField.keyboardType = noticeTextField.keyboardType
                }
            }
        } else {
            print("Notice Error: text fields are not supported in confirmation dialogs. Please use alert instead.")
        }
        noticeOptions.presentNotice(animated: flag, completion: completion)
    }
    
    /// Presents an alert notice that can have text fields (Confiramtion dialogs cannot have text fields)
    ///
    /// Example
    /// ```
    /// @State private var name = ""
    /// @State private var email = ""
    /// @State private var password = ""
    /// @State private var passwordCheck = ""
    /// ```
    /// ```
    /// let noticeOptions = NoticeOptions(NoticeOptionsValue(title: "Sign in"))
    ///
    /// var textFields: [NoticeTextField] = []
    /// textFields.append(NoticeTextField(title: "Name", autoCapitalizationType: .words))
    /// textFields.append(NoticeTextField(title: "Email", autoCapitalizationType: .none, keyboardType: .emailAddress))
    /// textFields.append(NoticeTextField(title: "Password", isSecure: true, keyboardType: .none))
    /// textFields.append(NoticeTextField(title: "Re-enter Password", isSecure: true, keyboardType: .none))
    ///
    /// var buttons: [NoticeButton] = []
    /// buttons.append(NoticeButton(title: "Submit", action: {
    ///      if noticeOptions.textFields?[2].text == noticeOptions.textFields?[3].text {
    ///          name = noticeOptions.textFields?[0].text ?? ""
    ///          email = noticeOptions.textFields?[1].text ?? ""
    ///          password = noticeOptions.textFields?[2].text ?? ""
    ///          passwordCheck = noticeOptions.textFields?[3].text ?? ""
    ///        }
    /// }))
    /// buttons.append(NoticeButton(.cancel, style: .cancel))
    ///
    /// Notice.present(noticeOptions, textFields: textFields, buttons: buttons)
    /// ```
    /// - Parameters:
    ///   - noticeOptions: optional title and message of the notice
    ///   - textFields: array of text fields
    ///   - buttons: buttons of the notice; default is none set, but addig a `default` button with an `OK` title instead
    public static func present(_ noticeOptions: NoticeOptions, textFields: [NoticeTextField], buttons: [NoticeButton] = []) {
        present(noticeOptions, textFields: textFields, buttons: buttons, animated: true, completion: nil)
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
    
    /// Create and return a notice button with the specified `title` from the `type` and optional `style` (default is `default`) and `action`
    /// - Parameters:
    ///   - type: type of the notice button
    ///   - style: style of the notice button, default is `default`
    ///   - action: action of the notice button
    convenience init(_ type: NoticeButtonType, style: Style = .default, action: (() -> ())? = nil) {
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
    
    /// Creates a notice that can have text fields
    /// - Parameter noticeOptionsValue: value with optional title and message
    convenience init(_ noticeOptionsValue: NoticeOptionsValue) {
        self.init(title: noticeOptionsValue.title, message: noticeOptionsValue.message, preferredStyle: .alert)
    }
    
    /// Presents a Notice on the root view controller with optional animation flag and completion
    /// - Parameters:
    ///   - flag: animation flag; default is `true`
    ///   - completion: completion callback
    func presentNotice(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        guard let topViewController = UIViewController.top() else {
            print("Notice Error: Failed to get top view controller")
            return
        }
        if let popoverController = self.popoverPresentationController {
            popoverController.sourceView = topViewController.view
            popoverController.sourceRect = CGRect(x: topViewController.view.bounds.midX, y: topViewController.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        topViewController.present(self, animated: flag, completion: completion)
    }
    
    /// Dismisses a Notice on the root view controller with optional animation flag and completion
    /// - Parameters:
    ///   - flag: animation flag; default is `true`
    ///   - completion: completion callback
    func dismissNotice(animated flag: Bool = true, completion: (() -> Void)? = nil) {
        UIViewController.top()?.dismiss(animated: flag, completion: completion)
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

public struct NoticeTextField {
    
    var title: String
    var isSecure: Bool
    var autoCapitalizationType: UITextAutocapitalizationType
    var keyboardType: UIKeyboardType
    
    /// Text Field for Notice
    /// - Parameters:
    ///   - title: title of the text field
    ///   - isSecure: is the text field secure; default is `false`
    ///   - autoCapitalizationType: text field auto capitalization type; default is `sentences`
    ///   - keyboardType: text field keyboard type; default is `default`
    public init(title: String,
                isSecure: Bool = false,
                autoCapitalizationType: UITextAutocapitalizationType = .sentences,
                keyboardType: UIKeyboardType = .default) {
        self.title = title
        self.isSecure = isSecure
        self.autoCapitalizationType = autoCapitalizationType
        self.keyboardType = keyboardType
    }
    
}

public struct NoticeOptionsValue {
    var title: String?
    var message: String?
    
    /// Notice optional title and message
    /// - Parameters:
    ///   - title: title of the notice; default is `nil`
    ///   - message: message of the notice; default is `nil`
    public init(title: String? = nil,
                message: String? = nil) {
        self.title = title
        self.message = message
    }
}
