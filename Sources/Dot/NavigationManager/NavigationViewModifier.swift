//
//  NavigationViewModifier.swift
//  Dot
//
//  Created by Alex Nagy on 09.08.2021.
//

import SwiftUI

public struct NavigationViewModifier: ViewModifier {
    
    @ObservedObject public var navigationManager: NavigationManager
    
    public func body(content: Content) -> some View {
        content
            .background(
                NavigationLink(isActive: $navigationManager.isPushed, destination: {
                    navigationManager.destination
                        .onDisappear {
                            navigationManager.onDismiss?()
                        }
                }, label: {
                    EmptyView()
                })
            )
            .sheet(isPresented: $navigationManager.isPresented, onDismiss: navigationManager.onDismiss) {
                navigationManager.destination
            }
            .fullScreenCover(isPresented: $navigationManager.isCovered, onDismiss: navigationManager.onDismiss) {
                navigationManager.destination
            }
    }
}

public extension View {
    func uses(_ navigationManager: NavigationManager) -> some View {
        modifier(NavigationViewModifier(navigationManager: navigationManager))
    }
}
