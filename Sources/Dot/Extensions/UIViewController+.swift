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
    
    /// Gets the top most view controller
    static func top() -> UIViewController? {
        var from = UIApplication.rootViewController()
        while (from != nil) {
            if let to = (from as? UITabBarController)?.selectedViewController {
                from = to
            } else if let to = (from as? UINavigationController)?.visibleViewController {
                from = to
            } else if let to = from?.presentedViewController {
                from = to
            } else {
                break
            }
        }
        return from
    }
}
