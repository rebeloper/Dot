//
//  Array+.swift
//  Dot
//
//  Created by Alex Nagy on 17.08.2021.
//

import Foundation

/// Makes `Array` `Codable` to be able to use arrays with @AppStorage
extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

public extension Array {
    
    /// The second element of the collection.
    ///
    /// If the collection is empty, the value of this property is `nil`.
    @inlinable var second: Element? {
        self[1]
    }
    
    /// The third element of the collection.
    ///
    /// If the collection is empty, the value of this property is `nil`.
    @inlinable var third: Element? {
        self[2]
    }
    
    /// The fourth element of the collection.
    ///
    /// If the collection is empty, the value of this property is `nil`.
    @inlinable var fourth: Element? {
        self[3]
    }
    
    /// The fifth element of the collection.
    ///
    /// If the collection is empty, the value of this property is `nil`.
    @inlinable var fifth: Element? {
        self[4]
    }
    
    /// The sixth element of the collection.
    ///
    /// If the collection is empty, the value of this property is `nil`.
    @inlinable var sixth: Element? {
        self[5]
    }
    
    /// The seventh element of the collection.
    ///
    /// If the collection is empty, the value of this property is `nil`.
    @inlinable var seventh: Element? {
        self[6]
    }
    
    /// The eight element of the collection.
    ///
    /// If the collection is empty, the value of this property is `nil`.
    @inlinable var eight: Element? {
        self[7]
    }
    
    /// The nineth element of the collection.
    ///
    /// If the collection is empty, the value of this property is `nil`.
    @inlinable var nineth: Element? {
        self[8]
    }
    
    /// The tenth element of the collection.
    ///
    /// If the collection is empty, the value of this property is `nil`.
    @inlinable var tenth: Element? {
        self[9]
    }
}
