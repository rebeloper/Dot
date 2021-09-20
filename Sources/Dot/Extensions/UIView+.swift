//
//  UIView+.swift
//  
//
//  Created by Alex Nagy on 20.09.2021.
//

import UIKit

public extension UIView {
    func allSubviews() -> [UIView] {
        var subs = self.subviews
        for subview in self.subviews {
            let rec = subview.allSubviews()
            subs.append(contentsOf: rec)
        }
        return subs
    }
}
