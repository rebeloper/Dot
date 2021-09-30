//
//  ErrorView.swift
//  
//
//  Created by Alex Nagy on 30.09.2021.
//

import SwiftUI

public struct ErrorView: View {
    
    public let error: Error
    
    public var body: some View {
        let _ = print("ErrorView: \(error.localizedDescription)")
        Image(systemName: "exclamationmark.triangle.fill")
            .foregroundColor(.systemGray5)
    }
}

