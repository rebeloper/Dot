//
//  NotificationName.swift
//  
//
//  Created by Alex Nagy on 22.09.2021.
//

import Foundation

public protocol NotificationName {
    var name: Notification.Name { get }
}

public extension RawRepresentable where RawValue == String, Self: NotificationName {
    var name: Notification.Name {
        get {
            return Notification.Name(self.rawValue)
        }
    }
}
