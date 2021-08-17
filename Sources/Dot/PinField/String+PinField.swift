//
//  File.swift
//  File
//
//  Created by Alex Nagy on 17.08.2021.
//

import Foundation

public extension String {
    var digits: [Int] {
        var result = [Int]()
        for char in self {
            if let number = Int(String(char)) {
                result.append(number)
            }
        }
        return result
    }
}
