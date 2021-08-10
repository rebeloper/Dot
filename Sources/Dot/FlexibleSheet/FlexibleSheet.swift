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
    internal var closeButtonColor: UIColor = .gray
    internal var allowsDraggingToDismiss = false
    internal var allowsTapBackgroundToDismiss = true
    internal var showsCloseButton = true
    
    private let title: String?
    private let content: () -> Content
    private let cornerRadius: CGFloat
    private let additionalOffset: CGFloat // this is so we can drag the sheet up a bit
    
    private var actualContentInsets: EdgeInsets {
        return EdgeInsets(top: contentInsets.top, leading: contentInsets.leading, bottom: cornerRadius + additionalOffset + contentInsets.bottom, trailing: contentInsets.trailing)
    }
    
    
    public init(isPresented: Binding<Bool>,
                title: String? = nil,
                cornerRadius: CGFloat = 15,
                additionalOffset: CGFloat = 44,
                @ViewBuilder content: @escaping () -> Content) {
        _isPresented = isPresented
        self.title = title
        self.cornerRadius = cornerRadius
        self.additionalOffset = additionalOffset
        self.content = content
    }
    
    
    public var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                if isPresented {
                    
                    Color.black
                        .ignoresSafeArea()
                        .opacity(0.15)
                        .onTapGesture {
                            if allowsTapBackgroundToDismiss {
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
                            
                            titleView
                        }
                        .frame(height: height.value(with: geometry) + cornerRadius + additionalOffset)
                        .offset(y: cornerRadius + additionalOffset + dragOffset)
                    }
                    .transition(.verticalSlide(height.value(with: geometry)))
                    .highPriorityGesture(
                        dragGesture(geometry)
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
    
    private var titleView: IfLet {
        
        let titleView = IfLet(title) { title in
            
            VStack {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .font(Font.title.weight(.semibold))
                        .opacity(0)
                        .padding(EdgeInsets(top: 10, leading: 13, bottom: 0, trailing: 0))
                    Spacer()
                    Text(title)
                        .font(Font.headline.weight(.semibold))
                        .padding(EdgeInsets(top: 18, leading: 0, bottom: 0, trailing: 0))
                        .lineLimit(1)
                    Spacer()
                    if showsCloseButton {
                        closeButton
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 13))
                    }
                }
                Spacer()
            }
            
        } else: {
            
            VStack {
                HStack {
                    Spacer()
                    if showsCloseButton {
                        closeButton
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 13))
                    }
                }
                Spacer()
            }
        }
        
        return titleView
    }
    
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
        
        let button = Button {
            dismiss()
        } label: {
            ZStack {
                Image(systemName: "xmark.circle.fill")
                    .font(Font.title.weight(.semibold))
                    .accentColor(Color(UIColor.lightGray.withAlphaComponent(0.2)))
                Image(systemName: "xmark.circle.fill")
                    .font(Font.title.weight(.semibold))
                    .accentColor(Color(closeButtonColor))
            }
        }
        
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

