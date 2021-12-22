//
//  SearchableView.swift
//  
//
//  Created by Alex Nagy on 22.12.2021.
//

import SwiftUI

public struct SearchableView: View {
    
    @Binding var text: String
    var title: String
    private var options: SearchableViewOptions
    private var onSubmit: () -> ()
    private let onCancel: () -> ()
    
    /// Search Bar View
    /// - Parameters:
    ///   - text: text
    ///   - title: title
    ///   - options: options
    ///   - onSubmit: on submit
    ///   - onCancel: on cancel
    /// - Returns: Search Bar View
    public init(text: Binding<String>,
                title: String = "Search",
                options: SearchableViewOptions = SearchableViewOptions(),
                onSubmit: @escaping () -> () = {},
                onCancel: @escaping () -> () = {}) {
        self._text = text
        self.title = title
        self.options = options
        self.onSubmit = onSubmit
        self.onCancel = onCancel
    }
    
    public enum FocusedField: Hashable {
        case focus
    }
    
    @FocusState public var focusedField: FocusedField?
    
    public var body: some View {
        HStack(spacing: 9) {
            
            HStack(spacing: 3) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.systemGray3)
                TextField(title, text: $text)
                    .foregroundColor(.primary)
                    .autocapitalization(options.autocapitalization)
                    .keyboardType(options.keyboardType)
                    .submitLabel(.search)
                    .focused($focusedField, equals: .focus)
                    .onSubmit({
                        onSubmit()
                    })
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            focusedField = .focus
                        }
                    }
                if text != "", options.showsClearSearchButton {
                    Button {
                        text = ""
                        focusedField = nil
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(.systemGray3))
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 15, style: .continuous).foregroundColor(Color(.secondarySystemBackground))
            )
            
            if options.showsCancelButton {
                Button {
                    text = ""
                    focusedField = nil
                    onCancel()
                } label: {
                    Text("Cancel")
                }
            }
        }
        .padding()
    }
}


