//
//  RootNavigationView.swift
//  Dot
//
//  Created by Alex Nagy on 17.08.2021.
//

import SwiftUI

public struct RootNavigationView<Content: View>: View {
    
    @StateObject private var rootViewManager = RootViewManager()
    public var content: () -> (Content)
    
    public var body: some View {
        NavigationView { content() }
            .navigationViewStyle(StackNavigationViewStyle())
            .environmentObject(rootViewManager)
            .environment(\.rootPresentationMode, $rootViewManager.isActiveFromRoot)
    }
}

public extension View {
    func embedInRootNavigationView() -> some View {
        RootNavigationView() { self }
    }
}

public class RootViewManager: ObservableObject {
    @Published public var isActiveFromRoot = false
}

public struct RootPresentationModeKey: EnvironmentKey {
    public static let defaultValue: Binding<RootPresentationMode> = .constant(RootPresentationMode())
}

public extension EnvironmentValues {
    var rootPresentationMode: Binding<RootPresentationMode> {
        get { return self[RootPresentationModeKey.self] }
        set { self[RootPresentationModeKey.self] = newValue }
    }
}

public typealias RootPresentationMode = Bool

public extension RootPresentationMode {
    mutating func dismiss() {
        self.toggle()
    }
}




