//
//  UIApplication+.swift
//  
//
//  Created by Alex Nagy on 20.09.2021.
//

import UIKit

public extension UIApplication {
    var keyWindow: UIWindow? {
        self.connectedScenes
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?
            .windows
            .filter({$0.isKeyWindow})
            .first
    }
}
