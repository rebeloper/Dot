//
//  TabBarAccessor.swift
//  
//
//  Created by Alex Nagy on 20.09.2021.
//

import SwiftUI

public struct TabBarAccessor: UIViewControllerRepresentable {
    public var callback: (UITabBar) -> Void
    public let proxyController = ViewController()
    
    public init(callback: (UITabBar) -> Void) {
        self.callback = callback
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarAccessor>) ->
    UIViewController {
        proxyController.callback = callback
        return proxyController
    }
    
    public func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<TabBarAccessor>) {
    }
    
    public typealias UIViewControllerType = UIViewController
    
    public class ViewController: UIViewController {
        public var callback: (UITabBar) -> Void = { _ in }
        
        public override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            if let tabBar = self.tabBarController {
                self.callback(tabBar.tabBar)
            }
        }
    }
}

