//
//  Log.swift
//  
//
//  Created by Alex Nagy on 10.03.2022.
//

import Foundation
import os.log

public struct Log {
    private static let infoLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "👉")
    private static let warningLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "⚠️")
    private static let errorLogger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "🛑")
    
    private init() {}

    public static func info(_ message: String) {
        infoLogger.error("\(message)")
    }
    
    public static func warning(_ message: String) {
        warningLogger.error("\(message)")
    }
    
    public static func error(_ message: String) {
        errorLogger.error("\(message)")
    }
    
    public static func error(_ error: Error) {
        errorLogger.error("\(error.localizedDescription)")
    }
}

