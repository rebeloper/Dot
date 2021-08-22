//
//  Dictionary+.swift
//  Dot
//
//  Created by Alex Nagy on 18.08.2021.
//

import Foundation

public extension Dictionary {
    mutating func merge(dict: [Key: Value]) {
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
