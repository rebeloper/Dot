//
//  NavigationStyle.swift
//  
//
//  Created by Alex Nagy on 08.12.2021.
//

import Foundation

/// Represents a style for how a view should be presented.
public enum NavigationStyle: Equatable {

    case regular(isDetailLink: Bool = false)
    case sheet
    case fullScreenCover

    public static let `default`: NavigationStyle = .regular(isDetailLink: false)
}
