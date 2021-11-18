//
//  File.swift
//  
//
//  Created by Alex Nagy on 18.11.2021.
//

import UIKit

public struct PrintInteractionController {
    
    public enum PrintingResult {
        case success
        case failure(Error)
        case userCancelled
    }

    public static func present(url: URL, printInfo: UIPrintInfo? = nil, completion: ((PrintingResult) -> Void)? = nil) {
        
        guard UIPrintInteractionController.isPrintingAvailable else {
            let error = NSError(domain: "Printing not available", code: 0, userInfo: nil)
            completion?(.failure(error))
            return
        }
        guard UIPrintInteractionController.canPrint(url) else {
            let error = NSError(domain: "Cannot print from url: \(url.absoluteString)", code: 1, userInfo: nil)
            completion?(.failure(error))
            return
        }
        
        let printController = UIPrintInteractionController()
        printController.printInfo = printInfo
        printController.printingItem = url
        printController.present(animated: true) { _, completed, error in
            guard let completion = completion else { return }
            if completed {
                completion(.success)
            } else {
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.userCancelled)
                }
            }
        }
    }
    
    public static func present(url: URL, printInfo: UIPrintInfo? = nil) async -> PrintingResult {
        await withCheckedContinuation({ continuation in
            present(url: url, printInfo: printInfo) { result in
                continuation.resume(returning: result)
            }
        })
    }
}

