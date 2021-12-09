//
//  TabItemNode.swift
//  
//
//  Created by Alex Nagy on 09.12.2021.
//

import SwiftUI

indirect enum TabItemNode<V: View>: View {
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
    }
}

