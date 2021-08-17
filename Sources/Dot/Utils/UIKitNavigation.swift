//
//  UIKitNavigation.swift
//  Dot
//
//  Created by Alex Nagy on 17.08.2021.
//

import UIKit
import SwiftUI

public struct UIKitNavigation {
    public static func popToRootView(_ windows: [UIWindow]) {
        findNavigationController(viewController: windows.filter { $0.isKeyWindow }.first?.rootViewController)?
            .popToRootViewController(animated: true)
    }
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        
        return nil
    }
}


