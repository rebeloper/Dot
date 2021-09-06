//
//  IndexedIdentifiable.swift
//  Dot
//
//  Created by Alex Nagy on 06.09.2021.
//

import SwiftUI

/// ``Identifaibale`` that has an ``Int`` index and an ``Identifiable`` element
public struct IndexedIdentifiable<T: Identifiable>: Identifiable {
    public let id = UUID().uuidString
    public let index: Int
    public let element: T
}

/// Indexes the array that has ``Identifiable`` elements
/// - Returns: an array of ``IndexedIdentifiable``s. ``IndexedIdentifiable`` has an ``index`` and an ``element``
public func indexed<T: Identifiable>(_ array: [T]) -> [IndexedIdentifiable<T>] {
    var indexedArray: [IndexedIdentifiable<T>] = []
    for i in 0..<array.count {
        let element = array[i]
        let indexedIdentifiable = IndexedIdentifiable(index: i, element: element)
        indexedArray.append(indexedIdentifiable)
    }
    return indexedArray
}
