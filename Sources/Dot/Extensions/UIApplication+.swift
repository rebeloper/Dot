//
//  UIApplication+.swift
//  
//
//  Created by Alex Nagy on 30.09.2021.
//

import UIKit

public extension UIApplication {
    static func rootViewController() -> UIViewController? {
        self.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
    }
}
