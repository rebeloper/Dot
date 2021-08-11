//
//  Navigation.swift
//  Dot
//
//  Created by Alex Nagy on 09.08.2021.
//

import SwiftUI

public class Navigation: ObservableObject {
    
    public init() {}
    
    @Published public var isPushed = false
    @Published public var isPresented = false
    @Published public var isCovered = false
    @Published public var destination: AnyView?
    @Published public var onDismiss: (() -> Void)?
    
    public func present<Destination: View>(_ type: NavigationType, @ViewBuilder destination: () -> (Destination), onDismiss: (() -> Void)? = nil) {
        self.destination = AnyView(destination())
        switch type {
        case .page:
            self.onDismiss = onDismiss
            isPushed = true
        case .sheet:
            self.onDismiss = onDismiss
            isPresented = true
        case .fullScreenCover:
            self.onDismiss = onDismiss
            isCovered = true
        }
    }
    
}
