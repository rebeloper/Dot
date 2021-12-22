//
//  SearchableViewModifier.swift
//  
//
//  Created by Alex Nagy on 22.12.2021.
//

import SwiftUI

public struct SearchableViewModifier: ViewModifier {
    
    @Binding public var text: String
    public let title: String
    public let options: SearchableViewOptions
    public let onSubmit: () -> ()
    public let onCancel: () -> ()
    
    // MARK: - Body
    public func body(content: Content) -> some View {
        VStack(spacing: 0) {
            SearchableView(text: $text,
                           title: title,
                           options: options,
                           onSubmit: onSubmit,
                           onCancel: onCancel)
            content
        }
    }
}

public extension View {
    func searchable(_ text: Binding<String>,
                    title: String = "Search",
                    options: SearchableViewOptions = SearchableViewOptions(),
                    onSubmit: @escaping () -> () = {},
                    onCancel: @escaping () -> () = {}) -> some View {
        modifier(SearchableViewModifier(
            text: text,
            title: title,
            options: options,
            onSubmit: onSubmit,
            onCancel: onCancel))
    }
}

