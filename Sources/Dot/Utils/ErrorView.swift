//
//  ErrorView.swift
//  
//
//  Created by Alex Nagy on 30.09.2021.
//

import SwiftUI

public struct ErrorView: View {
    
    private let error: Error
    
    public init(_ error: Error) {
        self.error = error
    }
    
    public var body: some View {
        let _ = print("ErrorView: \(error.localizedDescription)")
        Image(systemName: "exclamationmark.triangle.fill")
            .imageScale(.large)
            .foregroundColor(.systemGray5)
            .asPushOutView()
    }
}

