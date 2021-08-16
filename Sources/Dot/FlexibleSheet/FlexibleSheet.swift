//
//  FlexibleSheet.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI
import Combine

public struct FlexibleSheet<Content: View>: View {
    
    @Binding private var isPresented: Bool
    @State private var hasAppeared = false
    @State private var dragOffset: CGFloat = 0
    
    internal var height: FlexibleSheetHeight = .proportional(0.84) // about the same as a ColorPicker
    internal var contentInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    internal var backgroundColor: UIColor = .systemBackground
    internal var closeButtonColor: UIColor = .lightGray
    internal var outsideColor: UIColor = .label
    internal var outsideOpacity: CGFloat = 0.15
    internal var allowsDraggingToDismiss = false
    internal var allowsTapOutsideToDismiss = true
    internal var showsCloseButton = true
    internal var cornerRadius: CGFloat = 15
    internal var additionalOffset: CGFloat = 44
    
    private let content: () -> Content
    
    private var actualContentInsets: EdgeInsets {
        return EdgeInsets(top: contentInsets.top, leading: contentInsets.leading, bottom: additionalOffset + contentInsets.bottom, trailing: contentInsets.trailing)
    }
    
    
    public init(isPresented: Binding<Bool>,
                @ViewBuilder content: @escaping () -> Content) {
        _isPresented = isPresented
        self.content = content
    }
    
    
    public var body: some View {
        
        GeometryReader { proxy in
            
            ZStack {
                
                if isPresented {
                    
                    Color(uiColor: outsideColor)
                        .ignoresSafeArea()
                        .opacity(outsideOpacity)
                        .onTapGesture {
                            if allowsTapOutsideToDismiss {
                                dismiss()
                            }
                        }
                        .transition(.opacity)
                        .onAppear { // we don't want the content to slide up until the background has appeared
                            withAnimation {
                                hasAppeared = true
                            }
                        }
                        .onDisappear() {
                            withAnimation {
                                hasAppeared = false
                            }
                        }
                }
                
                if hasAppeared {
                    
                    VStack {
                        
                        Spacer()
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .foregroundColor(.systemWhite)
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .foregroundColor(Color(backgroundColor))
                            
                            content()
                                .padding(actualContentInsets)
                                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            if showsCloseButton {
                                VStack {
                                    HStack {
                                        Spacer()
                                        closeButton
                                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 13))
                                    }
                                    Spacer()
                                }
                            }
                        }
                        .frame(height: height.value(with: proxy) + additionalOffset + proxy.safeAreaInsets.bottom)
                        .offset(y: additionalOffset + proxy.safeAreaInsets.bottom + dragOffset)
                    }
                    .transition(.verticalSlide(height.value(with: proxy)))
                    .highPriorityGesture(
                        dragGesture(proxy)
                    )
                    .onDisappear {
                        dragOffset = 0
                    }
                }
            }
        }
    }
}


// MARK: - Private
extension FlexibleSheet {
    
    private func dragGesture(_ geometry: GeometryProxy) -> _EndedGesture<_ChangedGesture<DragGesture>> {
        
        let gesture = DragGesture(minimumDistance: 44)
            .onChanged {
                
                guard allowsDraggingToDismiss else {
                    return
                }
                
                let offset = $0.translation.height
                dragOffset = offset > 0 ? offset : sqrt(-offset) * -1
            }
            .onEnded {
                
                guard allowsDraggingToDismiss else {
                    return
                }
                
                if dragOffset > 0, $0.predictedEndTranslation.height / $0.translation.height > 2 {
                    dismiss()
                    return
                }
                
                let validDragDistance = height.value(with: geometry) / 2
                if dragOffset < validDragDistance {
                    withAnimation {
                        dragOffset = 0
                    }
                } else {
                    dismiss()
                }
            }
        
        return gesture
    }
    
    private var closeButton: AnyView {
        
        let button = SFButton(action: {
            dismiss()
        }, name: "xmark.circle.fill", font: Font.title.weight(.semibold))
            .accentColor(Color(closeButtonColor))
        
        return AnyView(button)
    }
    
    private func dismiss() {
        
        withAnimation {
            hasAppeared = false
            isPresented = false
        }
    }
}


public enum FlexibleSheetHeight {
    case fixed(CGFloat)
    case proportional(CGFloat)
    
    func value(with proxy: GeometryProxy) -> CGFloat {
        switch self {
        case .fixed(let height):
            return height
        case .proportional(let proportion):
            return proxy.size.height > proxy.size.width ?  proxy.size.height * proportion : proxy.size.width * proportion
        }
    }
}

