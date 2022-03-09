//
//  NavigatableStyle.swift
//  
//
//  Created by Alex Nagy on 08.03.2022.
//

import Foundation

/// Navigation View styles
public enum NavigatableStyle {
    /// No navigation view style is being applied to the NavigationView
    case none
    
    /// A navigation view style represented by a view stack that only shows a
    /// single top view at a time.
    case stack
    
    /// The default navigation view style in the current context of the view
    /// being styled.
    case automatic
    
    /// A navigation view style represented by a series of views in columns.
    case columns
}
