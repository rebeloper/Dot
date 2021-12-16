//
//  Toast.swift
//  
//
//  Created by Alex Nagy on 16.12.2021.
//

import SwiftUI

public struct Toast {
    
    /// Presents a Toast
    /// - Parameters:
    ///   - title: title of the Toast
    ///   - message: message of the Toast
    ///   - showsErrorNotice: should a ``Notice`` be shown when an ``Error`` is thrown
    ///   - manager: toast manager set up as ``@EnvironmentObject private var toastManager: ToastManager``
    ///   - action: action being taken while the Toast is presented; please complete with a ``Result<Bool, Error>``
    public static func present(_ title: String? = nil, message: String? = nil, showsErrorNotice: Bool = true, with manager: ToastManager, action: @escaping (@escaping (Result<Bool, Error>) -> ()) -> ()) {
        manager.present(title, message: message)
        action { result in
            switch result {
            case .success(_):
                manager.dismiss()
            case .failure(let error):
                manager.dismiss()
                if showsErrorNotice {
                    Notice.present(.error, message: error.localizedDescription)
                }
            }
        }
    }
    
    /// Presents a Toast in an async throws context
    /// - Parameters:
    ///   - title: title of the Toast
    ///   - message: message of the Toast
    ///   - showsErrorNotice: should a ``Notice`` be shown when an ``Error`` is thrown
    ///   - manager: toast manager set up as ``@EnvironmentObject private var toastManager: ToastManager``
    ///   - action: action being taken while the Toast is presented
    public static func presentThrowing(_ title: String? = nil, message: String? = nil, showsErrorNotice: Bool = true, with manager: ToastManager, action: @escaping () async throws -> ())  async throws {
        do {
            manager.present(title, message: message)
            try await action()
            manager.dismiss()
        } catch {
            manager.dismiss()
            if showsErrorNotice {
                Notice.present(.error, message: error.localizedDescription)
            }
            throw error
        }
    }
    
    /// Presents a Toast in an async context
    /// - Parameters:
    ///   - title: title of the Toast
    ///   - message: message of the Toast
    ///   - manager: toast manager set up as ``@EnvironmentObject private var toastManager: ToastManager``
    ///   - action: action being taken while the Toast is presented
    public static func present(_ title: String? = nil, message: String? = nil, with manager: ToastManager, action: @escaping () async -> ()) async {
        manager.present(title, message: message)
        await action()
        manager.dismiss()
    }
    
}

