//
//  RangeReplaceableCollection+.swift
//  
//
//  Created by Alex Nagy on 06.02.2022.
//

import Foundation

public extension RangeReplaceableCollection where Self.Element: Equatable {
    @discardableResult
    /// Removes the first found element
    /// - Parameter element: element to be removed
    /// - Returns: optional, discardable element
    mutating func remove(element: Element) -> Element? {
        guard let index = firstIndex(where: { $0 == element }) else { return nil }
        return remove(at: index)
    }
}

public extension RangeReplaceableCollection {
    @discardableResult
    /// Removes the first element that fulfills the predicate
    /// - Parameter predicate: condition for the first element to be removed
    /// - Returns: optional, discardable element
    mutating func removeFirst(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        guard let index = try firstIndex(where: predicate) else { return nil }
        return remove(at: index)
    }
}

public extension RangeReplaceableCollection where Self: BidirectionalCollection {
    @discardableResult
    /// Removes the last element that fulfills the predicate
    /// - Parameter predicate: condition for the last element to be removed
    /// - Returns: optional, discardable element
    mutating func removeLast(where predicate: (Element) throws -> Bool) rethrows -> Element? {
        guard let index = try lastIndex(where: predicate) else { return nil }
        return remove(at: index)
    }
}
