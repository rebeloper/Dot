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
    
    public init(tags: Int..., options: TabsStackOptions = TabsStackOptions()) {
        setupTabs(tags: tags, options: options)
    }
    
    public init(tags: [Int], options: TabsStackOptions = TabsStackOptions()) {
        setupTabs(tags: tags, options: options)
    }
    
    public init(count: Int, options: TabsStackOptions = TabsStackOptions()) {
        guard count > 0 else {
            fatalError("Tab tags count must be greater than 0")
        }
        stack = TabStack(count: count)
        self.options = options
    }
    
    private func setupTabs(tags: [Int], options: TabsStackOptions) {
        guard tags.count > 0 else {
            fatalError("Tab tags count must be greater than 0")
        }
        stack = TabStack(tags: tags)
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
    
    func presentTab(atIndex index: Int, animated: Bool = false) {
        guard index < stack.tags.count else { return }
        execute(animated) {
            selection = index
        }
    }
    
    func presentTab(withTag tag: Int, animated: Bool = false) {
        guard let index = stack.tags.firstIndex(of: tag) else { return }
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
    
    func insertTab(withTag tag: Int, at index: Int, animated: Bool = true) {
        guard !stack.tags.contains(tag) else { return }
        guard index < stack.tags.count else { return }
        execute(animated) {
            stack.tags.insert(tag, at: index)
        }
    }
    
    func insertTabs(withTags tags: [Int] at indices: [Int], animated: Bool = true) {
        guard tags.count == indices.count else { return }
        for i in 0..<tags.count {
            insertTab(withTag: tags[i], at: indices[i], animated: animated)
        }
    }
    
    func removeTab(withTag tag: Int, animated: Bool = true) {
        guard let index = stack.tags.firstIndex(of: tag) else { return }
        execute(animated) {
            stack.tags.remove(at: index)
        }
    }
    
    func removeTab(at index: Int, animated: Bool = true) {
        guard index < stack.tags.count else { return }
        execute(animated) {
            stack.tags.remove(at: index)
        }
    }
    
    func removeTabs(withTags tags: [Int], animated: Bool = true) {
        tags.forEach { tag in
            removeTab(withTag: tag, animated: animated)
        }
    }
    
    func removeTabs(withIndices indices: [Int], animated: Bool = true) {
        indices.forEach { index in
            removeTab(at: index, animated: animated)
        }
    }
    
    func moveTab(withTag tag: Int, to index: Int, animated: Bool = true) {
        guard index < stack.tags.count else { return }
        guard let currentIndex = stack.tags.firstIndex(of: tag) else { return }
        execute(animated) {
            stack.tags.move(fromIndex: currentIndex, toIndex: index)
        }
    }
    
    func moveTab(fromIndex currentIndex: Int, to index: Int, animated: Bool = true) {
        guard currentIndex < stack.tags.count else { return }
        guard index < stack.tags.count else { return }
        execute(animated) {
            stack.tags.move(fromIndex: currentIndex, toIndex: index)
        }
    }
    
    func swapTab(withTag tag: Int, withOtherTabWithTag otherTag: Int, animated: Bool = true) {
        guard let tabIndex = stack.tags.firstIndex(of: tag) else { return }
        guard let otherTabIndex = stack.tags.firstIndex(of: otherTag) else { return }
        execute(animated) {
            stack.tags.swapAt(tabIndex, otherTabIndex)
        }
    }
    
    func swapTab(at index: Int, with otherIndex: Int, animated: Bool = true) {
        guard index < stack.tags.count else { return }
        guard otherIndex < stack.tags.count else { return }
        execute(animated) {
            stack.tags.swapAt(index, otherIndex)
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

