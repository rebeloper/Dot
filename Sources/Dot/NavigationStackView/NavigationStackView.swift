//
//  NavigationStackView.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

public struct NavigationStackView<Content: View>: View {
    
    @StateObject private var navigationStackManager = NavigationStackManager()
    public var content: () -> (Content)
    
    public var body: some View {
        NavigationView { content() }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(navigationStackManager)
            .environment(\.navigationStack, $navigationStackManager.isActiveFromRoot)
    }
}

public extension View {
    func embedInNavigationStackView() -> some View {
        NavigationStackView() { self }
    }
}

public class NavigationStackManager: ObservableObject {
    @Published public var isActiveFromRoot = false
}

public struct NavigationStackKey: EnvironmentKey {
    public static let defaultValue: Binding<NavigationStack> = .constant(NavigationStack())
}

public extension EnvironmentValues {
    var navigationStack: Binding<NavigationStack> {
        get { return self[NavigationStackKey.self] }
        set { self[NavigationStackKey.self] = newValue }
    }
}

public typealias NavigationStack = Bool

public extension NavigationStack {
    mutating func popToRoot() {
        self.toggle()
    }
}





