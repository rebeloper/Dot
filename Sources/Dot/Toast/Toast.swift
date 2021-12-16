//
//  Toast.swift
//  
//
//  Created by Alex Nagy on 16.12.2021.
//

import SwiftUI

public struct Toast {
    
    public typealias CompletionToastAction = (Result<Bool, Error>) -> ()
    
    public static func present(_ manager: ToastManager, title: String? = nil, message: String? = nil, showsErrorNotice: Bool = true, action: @escaping (@escaping CompletionToastAction) -> ()) {
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
    
    public static func presentThrowing(_ manager: ToastManager, title: String? = nil, message: String? = nil, showsErrorNotice: Bool = true, action: @escaping () async throws -> ())  async throws {
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
    
    public static func present(_ manager: ToastManager, title: String? = nil, message: String? = nil, action: @escaping () async -> ()) async {
        manager.present(title, message: message)
        await action()
        manager.dismiss()
    }
    
}

