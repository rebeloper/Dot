//
//  InfiniteProgressBar.swift
//  Dot
//
//  Created by Alex Nagy on 14.09.2021.
//

import SwiftUI

public struct InfiniteProgressBar: View {
    
    @State private var animationPhase = true
    
    @Binding private var isActive: Bool
    private var barWidthPercentage: CGFloat
    private var offsetWidthPercentage: CGFloat
    private var foregroundColor: Color
    private var backgroundColor: Color
    private var animationDuration: Double
    
    public init(_ isActive: Binding<Bool>,
         barWidthPercentage: CGFloat = 0.5,
         offsetWidthPercentage: CGFloat = 0.8,
         foregroundColor: Color = Color.blue,
         backgroundColor: Color = Color.gray.opacity(0.5),
         animationDuration: Double = 1) {
        self._isActive = isActive
        self.barWidthPercentage = barWidthPercentage
        self.offsetWidthPercentage = offsetWidthPercentage
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.animationDuration = animationDuration
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                Rectangle()
                    .foregroundColor(backgroundColor)
                Rectangle()
                    .foregroundColor(foregroundColor)
                    .frame(width: proxy.size.width * barWidthPercentage)
                    .offset(x: animationPhase ? -proxy.size.width * offsetWidthPercentage : proxy.size.width * offsetWidthPercentage)
            }
            .clipped()
        }
        .opacity(isActive ? 1 : 0)
        .onAppear {
            withAnimation(.easeInOut(duration: animationDuration).repeatForever(autoreverses: true)) {
                animationPhase.toggle()
            }
        }
    }
}


