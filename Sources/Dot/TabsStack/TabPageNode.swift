//
//  TabPageNode.swift
//  
//
//  Created by Alex Nagy on 09.12.2021.
//

import Foundation
import SwiftUI

indirect enum TabPageNode<V: View>: View {
    case view(V, stack: Binding<TabStack>, index: Int, selection: Binding<Int>)
    
    private var isActive: Bool {
        switch self {
        case .view(_ , _, let index, let selection):
            return selection.wrappedValue == index
        }
    }
    
    @ViewBuilder
    private var presentedView: some View {
        switch self {
        case .view(let node, _, _, _):
            node
        }
    }
    
    var body: some View {
        presentedView
            .background {
                Color(uiColor: .systemBackground)
            }
            .opacity(isActive ? 1 : 0)
    }
}


