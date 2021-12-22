//
//  SearchableViewOptions.swift
//  
//
//  Created by Alex Nagy on 22.12.2021.
//

import SwiftUI

public struct SearchableViewOptions {
    public var showsCancelButton: Bool
    public var showsClearSearchButton: Bool
    public var autocapitalization: UIKit.UITextAutocapitalizationType
    public var keyboardType: UIKit.UIKeyboardType
    
    public init(showsCancelButton: Bool = false,
                showsClearSearchButton: Bool = true,
                autocapitalization: UIKit.UITextAutocapitalizationType = .sentences,
                keyboardType: UIKit.UIKeyboardType = .default) {
        self.showsCancelButton = showsCancelButton
        self.showsClearSearchButton = showsClearSearchButton
        self.autocapitalization = autocapitalization
        self.keyboardType = keyboardType
    }
}

