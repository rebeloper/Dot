//
//  TabsStackScrollView.swift
//  
//
//  Created by Alex Nagy on 09.12.2021.
//

import SwiftUI

public struct TabsStackScrollView<Content: View>: View {
    
    @EnvironmentObject private var tabs: Tabs
    
    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let content: () -> Content
    
    public init(axes: Axis.Set = .vertical,
                showsIndicators: Bool = false,
                @ViewBuilder content: @escaping () -> Content) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.content = content
    }
    
    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            VStack(spacing: 0) {
                content()
                Spacer().frame(height: tabs.visible ? tabs.options.height : 0)
            }
        }
    }
}

