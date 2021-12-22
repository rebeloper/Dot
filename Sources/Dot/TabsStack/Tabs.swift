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
    
    // Sets up 0 tabs tags; and options. Use this as a default value only
    public init() {
        stack = TabStack(count: 0)
        self.options = TabsStackOptions()
    }
    
    // Sets up tabs tags from a variadic array; and options
    /// - Parameters:
    ///   - tags: tab tags
    ///   - options: TabsStack options
    public init(tags: Int..., options: TabsStackOptions = TabsStackOptions()) {
        setupTabs(tags: tags, options: options)
    }
    
    /// Sets up tabs tags from a variadic array; and options
    /// - Parameters:
    ///   - tags: tab tags
    ///   - options: TabsStack options
    public init(tags: [Int], options: TabsStackOptions = TabsStackOptions()) {
        setupTabs(tags: tags, options: options)
    }
    
    /// Set up tab tags from a count and options
    /// - Parameters:
    ///   - count: tab tags
    ///   - options: TabsStack options
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
    
    /// Executes an action with or without an animation
    /// - Parameters:
    ///   - animationFlag: animation flag
    ///   - action: the action to be executed
    func execute(with animationFlag: Bool, action: () -> ()) {
        if animationFlag {
            withAnimation {
                action()
            }
        } else {
            action()
        }
    }
    
    /// Switches to the tab at index
    /// - Parameters:
    ///   - index: the index of the tab
    ///   - flag: animation flag; default is `false`
    func presentTab(atIndex index: Int, animated flag: Bool = false) {
        guard index < stack.tags.count else { return }
        execute(with: flag) {
            selection = index
        }
    }
    
    /// Switches to the tab with tag
    /// - Parameters:
    ///   - tag: the tag of the tab
    ///   - flag: animation flag; default is `false`
    func presentTab(withTag tag: Int, animated flag: Bool = false) {
        guard let index = stack.tags.firstIndex(of: tag) else { return }
        execute(with: flag) {
            selection = index
        }
    }
    
    /// Shows the TabsStack
    /// - Parameter flag: animation flag; default is `true`
    func show(animated flag: Bool = true) {
        execute(with: flag) {
            visible = true
        }
    }
    
    /// Hides the TabsStack
    /// - Parameter flag: animation flag; default is `true`
    func hide(animated flag: Bool = true) {
        execute(with: flag) {
            visible = false
        }
    }
    
    /// Toggles (shows/hides) the TabStack's visibility
    /// - Parameter flag: animation flag; default is `true`
    func toggleVisibility(animated flag: Bool = true) {
        execute(with: flag) {
            visible.toggle()
        }
    }
    
    /// Inserts a tab with a tag at an index
    /// - Parameters:
    ///   - tag: tab tag
    ///   - index: tab index
    ///   - flag: animation flag; default is `true`
    func insertTab(withTag tag: Int, at index: Int, animated flag: Bool = true) {
        guard !stack.tags.contains(tag) else { return }
        var index = index
        if index >= stack.tags.count {
            index = stack.tags.count
        }
        execute(with: flag) {
            stack.tags.insert(tag, at: index)
        }
    }
    
    /// Inserts a tabs with a tags at an indices
    /// - Parameters:
    ///   - tags: tabs tags
    ///   - indices: tabs indices
    ///   - flag: animation flag; default is `true`
    func insertTabs(withTags tags: [Int], at indices: [Int], animated flag: Bool = true) {
        guard tags.count == indices.count else { return }
        for i in 0..<tags.count {
            insertTab(withTag: tags[i], at: indices[i], animated: flag)
        }
    }
    
    /// Removes a tab with a tag
    /// - Parameters:
    ///   - tag: tab tag
    ///   - flag: animation flag; default is `true`
    func removeTab(withTag tag: Int, animated flag: Bool = true) {
        guard let index = stack.tags.firstIndex(of: tag) else { return }
        execute(with: flag) {
            stack.tags.remove(at: index)
        }
    }
    
    /// Removes a tab at index
    /// - Parameters:
    ///   - index: tab index
    ///   - flag: animation flag; default is `true`
    func removeTab(at index: Int, animated flag: Bool = true) {
        guard index < stack.tags.count else { return }
        execute(with: flag) {
            stack.tags.remove(at: index)
        }
    }
    
    /// Removes tabs with tags
    /// - Parameters:
    ///   - tags: tabs tags
    ///   - flag: animation flag; default is `true`
    func removeTabs(withTags tags: [Int], animated flag: Bool = true) {
        tags.forEach { tag in
            removeTab(withTag: tag, animated: flag)
        }
    }
    
    /// Removes tabs at indices
    /// - Parameters:
    ///   - indices: tabs indices
    ///   - flag: animation flag; default is `true`
    func removeTabs(atIndices indices: [Int], animated flag: Bool = true) {
        indices.forEach { index in
            removeTab(at: index, animated: flag)
        }
    }
    
    /// Moves tab with tag to an index
    /// - Parameters:
    ///   - tag: tab tag
    ///   - index: destination index
    ///   - flag: animation flag; default is `true`
    func moveTab(withTag tag: Int, to index: Int, animated flag: Bool = true) {
        guard index < stack.tags.count else { return }
        guard let currentIndex = stack.tags.firstIndex(of: tag) else { return }
        execute(with: flag) {
            stack.tags.move(fromIndex: currentIndex, toIndex: index)
        }
    }
    
    /// Moves tab from an index to another index
    /// - Parameters:
    ///   - currentIndex: tab current index
    ///   - index: tab destination index
    ///   - flag: animation flag; default is `true`
    func moveTab(fromIndex currentIndex: Int, to index: Int, animated flag: Bool = true) {
        guard currentIndex < stack.tags.count else { return }
        guard index < stack.tags.count else { return }
        execute(with: flag) {
            stack.tags.move(fromIndex: currentIndex, toIndex: index)
        }
    }
    
    /// Swaps two tabs with tags
    /// - Parameters:
    ///   - tag: tab tag
    ///   - otherTag: other tab tag
    ///   - flag: animation flag; default is `true`
    func swapTab(withTag tag: Int, withOtherTabWithTag otherTag: Int, animated flag: Bool = true) {
        guard let tabIndex = stack.tags.firstIndex(of: tag) else { return }
        guard let otherTabIndex = stack.tags.firstIndex(of: otherTag) else { return }
        execute(with: flag) {
            stack.tags.swapAt(tabIndex, otherTabIndex)
        }
    }
    
    /// Swaps two tabs with indices
    /// - Parameters:
    ///   - index: tab index
    ///   - otherIndex: other tab index
    ///   - flag: animation flag; default is `true`
    func swapTab(at index: Int, with otherIndex: Int, animated flag: Bool = true) {
        guard index < stack.tags.count else { return }
        guard otherIndex < stack.tags.count else { return }
        execute(with: flag) {
            stack.tags.swapAt(index, otherIndex)
        }
    }
    
    /// Sets the tab item's selected color
    /// - Parameters:
    ///   - selectedColor: color
    ///   - flag: animation flag; default is `true`
    func setSelectedColor(_ selectedColor: Color, animated flag: Bool = true) {
        execute(with: flag) {
            options.selectedColor = selectedColor
        }
    }
    
    /// Sets the tab item's unselected color
    /// - Parameters:
    ///   - unselectedColor: color
    ///   - flag: animation flag; default is `true`
    func setUnselectedColor(_ unselectedColor: Color, animated flag: Bool = true) {
        execute(with: flag) {
            options.unselectedColor = unselectedColor
        }
    }
    
    /// Sets the TabsStack's height
    /// - Parameters:
    ///   - height: height
    ///   - flag: animation flag; default is `true`
    func setHeight(_ height: CGFloat, animated flag: Bool = true) {
        execute(with: flag) {
            options.height = height
        }
    }
    
    /// Raises the TabsStack's height
    /// - Parameters:
    ///   - amount: amount
    ///   - flag: animation flag; default is `true`
    func raiseHeight(by amount: CGFloat, animated flag: Bool = true) {
        execute(with: flag) {
            options.height += amount
        }
    }
    
    /// Lowers the TabsStack's height
    /// - Parameters:
    ///   - amount: amount
    ///   - flag: animation flag; default is `true`
    func lowerHeight(by amount: CGFloat, animated flag: Bool = true) {
        execute(with: flag) {
            options.height -= amount
        }
    }
    
    /// Shows the TabsStack's divider
    /// - Parameter flag: animation flag; default is `true`
    func showDivider(animated flag: Bool = true) {
        execute(with: flag) {
            options.showsDivider = true
        }
    }
    
    /// Hides the TabsStack's divider
    /// - Parameter flag: animation flag; default is `true`
    func hideDivider(animated flag: Bool = true) {
        execute(with: flag) {
            options.showsDivider = false
        }
    }
    
    /// Toggles the TabsStack's divider visibility
    /// - Parameter flag: animation flag; default is `true`
    func toggleDividerVisibility(animated flag: Bool = true) {
        execute(with: flag) {
            options.showsDivider.toggle()
        }
    }
    
    /// Sets the TabsStack's edge insets
    /// - Parameters:
    ///   - edgeInsets: edge instes
    ///   - flag: animation flag; default is `true`
    func setEdgeInsets(_ edgeInsets: EdgeInsets, animated flag: Bool = true) {
        execute(with: flag) {
            options.edgeInsets = edgeInsets
        }
    }
    
    /// Set the flag for the tab change animation
    /// - Parameter isTabChangeAnimated: animation flag
    func setIsTabChangeAnimated(_ isTabChangeAnimated: Bool) {
        options.isTabChangeAnimated = isTabChangeAnimated
    }
    
    /// Toggles the tab change animation flag
    func toggleIsTabChangeAnimated() {
        options.isTabChangeAnimated.toggle()
    }
}

