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

public struct Notice {
    
    /// Presents a notice with an `alert` / `confirmationDialog` style and optional `title`, `message` and `buttons`
    /// - Parameters:
    ///   - style: style of the notice
    ///   - title: title of the notice; default is `nil`
    ///   - message: message of the notice; default is `nil`
    ///   - buttons: buttons of the notice; default is none set, but addig a `cancel` button with an `OK` title instead
    public static func present(_ style: NoticeStyle, title: String? = nil, message: String? = nil, buttons: [NoticeButton] = []) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: getNoticeControllerStyle(for: style))
        if buttons.isEmpty {
            alert.addAction(NoticeButton(title: "OK", style: .cancel))
        } else {
            buttons.forEach { button in
                alert.addAction(button)
            }
        }
        alert.presentNotice()
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
    convenience init(title: String, style: Style, action: (() -> ())?) {
        self.init(title: title, style: style) { _ in
            action?()
        }
    }
}

public extension NoticeController {
    
    func presentNotice() {
        UIApplication.rootViewController()?.present(self, animated: true, completion: nil)
    }

    func dismissNotice() {
        UIApplication.rootViewController()?.dismiss(animated: true, completion: nil)
    }
}

public enum NoticeType {
    case error, success, warning, info
}

public enum NoticeStyle {
    case confirmationDialog, alert
}
