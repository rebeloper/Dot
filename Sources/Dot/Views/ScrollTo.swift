//
//  ScrollTo.swift
//  Dot
//
//  Created by Alex Nagy on 17.08.2021.
//

import SwiftUI

/// An Empty View inside a ScrollViewReader that scrolls to the specified id
/// - Parameters:
///   - id: the id of the View to be scrlled to
///   - proxy: ScrollViewReader proxy
/// - Returns: EmtpyView()
public func ScrollTo(id: Int, proxy: ScrollViewProxy) -> some View {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
        withAnimation {
            proxy.scrollTo(id)
        }
    }
    return EmptyView()
}

