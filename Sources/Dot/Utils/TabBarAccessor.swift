//
//  TabBarAccessor.swift
//  
//
//  Created by Alex Nagy on 20.09.2021.
//

import SwiftUI

public struct TabBarAccessor: UIViewControllerRepresentable {
    public var callback: (UITabBar) -> Void
    private let proxyController = ViewController()
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarAccessor>) ->
    UIViewController {
        proxyController.callback = callback
        return proxyController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TabBarAccessor>) {
    }
    
    public typealias UIViewControllerType = UIViewController
    
    private class ViewController: UIViewController {
        var callback: (UITabBar) -> Void = { _ in }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let tabBar = self.tabBarController {
                self.callback(tabBar.tabBar)
            }
        }
    }
}

