//
//  TabsStack+Array.swift
//  
//
//  Created by Alex Nagy on 09.12.2021.
//

import Foundation

public extension Array {
    mutating func move(fromIndex: Int, toIndex: Int) {
        let element = self.remove(at: fromIndex)
        self.insert(element, at: toIndex)
    }
}
