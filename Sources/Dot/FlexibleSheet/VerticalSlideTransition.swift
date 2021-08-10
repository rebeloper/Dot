//
//  VerticalSlideTransition.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

fileprivate struct VerticalSlideModifier: ViewModifier {
    
    let offset: CGFloat
    
    func body(content: Content) -> some View {
        
        content
            .offset(CGSize(width: 0, height: offset))
    }
}


extension AnyTransition {
    
    static func verticalSlide(_ offset: CGFloat? = nil) -> AnyTransition {
        
        .modifier(
            active: VerticalSlideModifier(offset: offset ?? UIScreen.main.bounds.height),
            identity: VerticalSlideModifier(offset: 0)
        )
    }
}

