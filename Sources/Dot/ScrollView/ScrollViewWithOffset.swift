//
//  ScrollViewWithOffset.swift
//  Dot
//
//  Created by Alex Nagy on 13.09.2021.
//

import SwiftUI

public struct ScrollViewWithOffset<Content: View>: View {
    private var axis: Axis.Set
    private var showsIndicators: Bool
    private var verticalAlignment: VerticalAlignment
    private var horizontalAlignment: HorizontalAlignment
    private var spacing: CGFloat?
    private var pinnedViews: PinnedScrollableViews
    private var onOffsetChange: ((CGFloat) -> Void)?
    private var content: () -> Content
    
    public init(_ axis: Axis.Set = .vertical,
                showsIndicators: Bool = true,
                verticalAlignment: VerticalAlignment = .center,
                horizontalAlignment: HorizontalAlignment = .center,
                spacing: CGFloat? = nil,
                pinnedViews: PinnedScrollableViews = .init(),
                onOffsetChange: ((CGFloat) -> Void)? = nil,
                @ViewBuilder content: @escaping () -> Content) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        self.spacing = spacing
        self.pinnedViews = pinnedViews
        self.onOffsetChange = onOffsetChange
        self.content = content
    }
    
    public var body: some View {
        ScrollView(axis, showsIndicators: showsIndicators) {
            if axis == .vertical {
                VStack {
                    scrollViewOffsetReader(axes: .vertical)
                    content().vertical(alignment: horizontalAlignment, spacing: spacing, pinnedViews: pinnedViews)
                }
            } else {
                HStack {
                    scrollViewOffsetReader(axes: .horizontal)
                    content().horizontal(alignment: verticalAlignment, spacing: spacing, pinnedViews: pinnedViews)
                }
            }
        }
        .coordinateSpace(name: "scrollViewOffsetReaderCoordinateSpaceName")
        .onPreferenceChange(ScrollViewOffsetPreferenceKey.self, perform: { offset in
            onOffsetChange?(offset)
        })
    }
    
    public func scrollViewOffsetReader(axes: Axis.Set) -> some View {
        GeometryReader { proxy in
            Color.clear
                .preference(
                    key: ScrollViewOffsetPreferenceKey.self,
                    value: axes == .vertical ? proxy.frame(in: .named("scrollViewOffsetReaderCoordinateSpaceName")).minY : proxy.frame(in: .named("scrollViewOffsetReaderCoordinateSpaceName")).minX
                )
        }
        .frame(width: axes == .vertical ? nil : 0, height: axes == .vertical ? 0 : nil)
    }
}
