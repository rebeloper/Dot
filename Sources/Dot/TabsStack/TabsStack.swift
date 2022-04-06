//
//  TabsStack.swift
//  
//
//  Created by Alex Nagy on 09.12.2021.
//

import Foundation
import SwiftUI

/// TabsStack maintains a stack of tabs.
public struct TabsStack<PageView: View, ItemView: View, BackgroundView: View>: View {
    
    @ObservedObject var tabs: Tabs
    
    @ViewBuilder var pages: (Int) -> PageView
    @ViewBuilder var items: (Int) -> ItemView
    @ViewBuilder var background: () -> BackgroundView
    var onSameItemTap: ((Int) -> ())?
    
    /// Creates a stack of tabs with pages, items and background.
    /// - Parameters:
    ///   - tabs: Holds the tab tags and options
    ///   - pages: Holds the pages of the tabs
    ///   - items: Holds the tab items of the tabs
    ///   - background: The background of the TabsStack
    ///   - onSameItemTap: An action trigerred when we tap on an already selected item
    public init(
        _ tabs: Tabs,
        @ViewBuilder pages: @escaping (Int) -> PageView,
        @ViewBuilder items: @escaping (Int) -> ItemView,
        @ViewBuilder background: @escaping () -> BackgroundView,
        onSameItemTap: ((_ selection: Int) -> ())? = nil
    ) {
        self.tabs = tabs
        self.pages = pages
        self.items = items
        self.background = background
        self.onSameItemTap = onSameItemTap
    }
    
    public var body: some View {
        ZStack {
            pagesView()
            tabBarView()
        }
        .environmentObject(tabs)
    }
}

public extension TabsStack {
    func pagesView() -> some View {
        ZStack {
            ForEach(tabs.stack.tags.indices, id:\.self) { index in
                TabPageNode<PageView>.view(
                    pages(tabs.stack.tags[index]),
                    stack: $tabs.stack,
                    index: index,
                    selection: $tabs.selection)
            }
        }
    }
    
    func tabBarView() -> some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                
                Spacer()
                
                VStack(spacing: 0) {
                    
                    if tabs.options.showsDivider {
                        Divider().ignoresSafeArea()
                    }
                    
                    HStack(spacing: 0) {
                        Spacer(minLength: 12)
                        itemsView(proxy: proxy)
                        Spacer(minLength: 12)
                    }
                    .frame(height: tabs.options.height)
                }
                .background(
                    background()
                )
                
            }
            .padding(tabs.options.edgeInsets)
            .transition(.slide)
            .offset(y: tabs.visible ? 0 : proxy.size.height)
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
    }
    
    func itemsView(proxy: GeometryProxy) -> some View {
        ForEach(tabs.stack.tags.indices, id:\.self) { index in
            TabItemNode<ItemView>.view(
                items(tabs.stack.tags[index]),
                stack: $tabs.stack,
                index: index,
                selection: $tabs.selection)
                .foregroundColor(index == tabs.selection ? tabs.options.selectedColor : tabs.options.unselectedColor)
                .onTapGesture {
                    if let onSameItemTap = onSameItemTap, tabs.selection == index {
                        onSameItemTap(index)
                    } else {
                        if tabs.options.isTabChangeAnimated {
                            withAnimation {
                                tabs.selection = index
                            }
                        } else {
                            tabs.selection = index
                        }
                    }
                }
                .frame(width: (proxy.size.width - 24 - tabs.options.edgeInsets.leading - tabs.options.edgeInsets.trailing - proxy.safeAreaInsets.leading - proxy.safeAreaInsets.trailing) / CGFloat(tabs.stack.tags.count))
        }
    }
    
}

