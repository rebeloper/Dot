//
//  Animation+.swift
//  Dot
//
//  Created by Alex Nagy on 14.09.2021.
//

import SwiftUI

public extension Animation {
    func `repeatForever`(while expression: Binding<Bool>, autoreverses: Bool = true) -> Animation {
        if expression.wrappedValue {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}
