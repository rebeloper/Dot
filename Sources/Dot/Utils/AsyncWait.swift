//
//  AsyncWait.swift
//  
//
//  Created by Alex Nagy on 16.12.2021.
//

import SwiftUI

public struct AsyncWait {
    
    /// Waits for an amount of time
    /// - Parameter value: Time to wait
    public static func `for`(_ value: DispatchTimeInterval) async {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + value) {
                continuation.resume()
            }
        }
    }
}

