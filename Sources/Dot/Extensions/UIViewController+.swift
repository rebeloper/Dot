//
//  UIViewController+.swift
//  Dot
//
//  Created by Alex Nagy on 17.08.2021.
//

import UIKit

public extension UIViewController {
    
    /// Root parent of the UIViewController
    var rootParent: UIViewController {
        if let parent = self.parent {
            return parent.rootParent
        }
        else {
            return self
        }
    }
}
