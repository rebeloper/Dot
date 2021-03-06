//
//  Bundle+.swift
//  Dot
//
//  Created by Alex Nagy on 17.08.2021.
//

import Foundation

public extension Bundle {
    static func getStringValue(forKey: String) -> String {
        guard let value = self.main.infoDictionary?[forKey] as? String else {
            fatalError("No value found for key '\(forKey)' in the Info.plist file")
        }
        return value
    }
    
    struct Key {
        public static let CFBundleIdentifier = "CFBundleIdentifier"
        public static let CFBundleName = "CFBundleName"
        public static let CFBundleShortVersionString = "CFBundleShortVersionString"
        public static let CFBundleVersion = "CFBundleVersion"
    }
}

