//
//  Tabs.swift
//  
//
//  Created by Alex Nagy on 09.12.2021.
//

import SwiftUI

public class Tabs: ObservableObject {
    
    @Published public var stack = TabStack()
    @Published public var selection = 0
    @Published public var visible = true
    @Published public var options = TabsStackOptions()
    
    public init(_ tabs: Int..., options: TabsStackOptions = TabsStackOptions()) {
        setupTabs(tabs, options: options)
    }
    
    public init(_ tabs: [Int], options: TabsStackOptions = TabsStackOptions()) {
        setupTabs(tabs, options: options)
    }
    
    public init(count: Int, options: TabsStackOptions = TabsStackOptions()) {
        guard count > 0 else {
            fatalError("Tabs count must be greater than 0")
        }
        stack = TabStack(count: count)
        self.options = options
    }
    
    private func setupTabs(_ tabs: [Int], options: TabsStackOptions) {
        guard tabs.count > 0 else {
            fatalError("Tabs count must be greater than 0")
        }
        stack = TabStack(tabs: tabs)
        self.options = options
    }
}

public extension Tabs {
    
    func execute(_ animated: Bool, action: () -> ()) {
        if animated {
            withAnimation {
                action()
            }
        } else {
            action()
        }
    }
    
    func present(index: Int, animated: Bool = false) {
        guard index < stack.tabs.count else { return }
        execute(animated) {
            selection = index
        }
    }
    
    func present(tab: Int, animated: Bool = false) {
        guard let index = stack.tabs.firstIndex(of: tab) else { return }
        execute(animated) {
            selection = index
        }
    }
    
    func show(animated: Bool = true) {
        execute(animated) {
            visible = true
        }
    }
    
    func hide(animated: Bool = true) {
        execute(animated) {
            visible = false
        }
    }
    
    func toggleVisibility(animated: Bool = true) {
        execute(animated) {
            visible.toggle()
        }
    }
    
    func insert(tab: Int, animated: Bool = true) {
        guard !stack.tabs.contains(tab) else { return }
        execute(animated) {
            stack.tabs.insert(tab, at: tab)
        }
    }
    
    func insert(tab: Int, at index: Int, animated: Bool = true) {
        guard !stack.tabs.contains(tab) else { return }
        guard index < stack.tabs.count else { return }
        execute(animated) {
            stack.tabs.insert(tab, at: index)
        }
    }
    
    func insert(tabs: [Int], animated: Bool = true) {
        tabs.forEach { tab in
            insert(tab: tab, animated: animated)
        }
    }
    
    func remove(tab: Int, animated: Bool = true) {
        guard let index = stack.tabs.firstIndex(of: tab) else { return }
        execute(animated) {
            stack.tabs.remove(at: index)
        }
    }
    
    func remove(at index: Int, animated: Bool = true) {
        guard index < stack.tabs.count else { return }
        execute(animated) {
            stack.tabs.remove(at: index)
        }
    }
    
    func remove(tabs: [Int], animated: Bool = true) {
        tabs.forEach { tab in
            remove(tab: tab, animated: animated)
        }
    }
    
    func move(tab: Int, to index: Int, animated: Bool = true) {
        guard index < stack.tabs.count else { return }
        guard let currentIndex = stack.tabs.firstIndex(of: tab) else { return }
        execute(animated) {
            stack.tabs.move(fromIndex: currentIndex, toIndex: index)
        }
    }
    
    func swap(tab: Int, with otherTab: Int, animated: Bool = true) {
        guard let tabIndex = stack.tabs.firstIndex(of: tab) else { return }
        guard let otherTabIndex = stack.tabs.firstIndex(of: otherTab) else { return }
        execute(animated) {
            stack.tabs.swapAt(tabIndex, otherTabIndex)
        }
    }
    
    func swap(index: Int, with otherIndex: Int, animated: Bool = true) {
        guard index < stack.tabs.count else { return }
        guard otherIndex < stack.tabs.count else { return }
        execute(animated) {
            stack.tabs.swapAt(index, otherIndex)
        }
    }
    
    func setSelectedColor(_ selectedColor: Color, animated: Bool = true) {
        execute(animated) {
            options.selectedColor = selectedColor
        }
    }
    
    func setUnselectedColor(_ unselectedColor: Color, animated: Bool = true) {
        execute(animated) {
            options.unselectedColor = unselectedColor
        }
    }
    
    func setHeight(_ height: CGFloat, animated: Bool = true) {
        execute(animated) {
            options.height = height
        }
    }
    
    func raiseHeight(by height: CGFloat, animated: Bool = true) {
        execute(animated) {
            options.height += height
        }
    }
    
    func lowerHeight(by height: CGFloat, animated: Bool = true) {
        execute(animated) {
            options.height -= height
        }
    }
    
    func showDivider(animated: Bool = true) {
        execute(animated) {
            options.showsDivider = true
        }
    }
    
    func hideDivider(animated: Bool = true) {
        execute(animated) {
            options.showsDivider = false
        }
    }
    
    func toggleDividerVisibility(animated: Bool = true) {
        execute(animated) {
            options.showsDivider.toggle()
        }
    }
    
    func setEgdeInsets(_ edgeInsets: EdgeInsets, animated: Bool = true) {
        execute(animated) {
            options.edgeInsets = edgeInsets
        }
    }
    
    func setIsTabChangeAnimated(_ isTabChangeAnimated: Bool) {
        options.isTabChangeAnimated = isTabChangeAnimated
    }
    
    func toggleIsTabChangeAnimated() {
        options.isTabChangeAnimated.toggle()
    }
}

