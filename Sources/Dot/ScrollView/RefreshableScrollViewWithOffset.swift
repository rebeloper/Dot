//
//  RefreshableScrollViewWithOffset.swift
//  Dot
//
//  Created by Alex Nagy on 06.09.2021.
//

import SwiftUI

// There are two type of positioning views - one that scrolls with the content,
// and one that stays fixed
private enum PositionType {
    case fixed, moving
}

// This struct is the currency of the Preferences, and has a type
// (fixed or moving) and the actual Y-axis value.
// It's Equatable because Swift requires it to be.
private struct Position: Equatable {
    let type: PositionType
    let y: CGFloat
    let x: CGFloat
}

// This might seem weird, but it's necessary due to the funny nature of
// how Preferences work. We can't just store the last position and merge
// it with the next one - instead we have a queue of all the latest positions.
private struct PositionPreferenceKey: PreferenceKey {
    typealias Value = [Position]
    
    static var defaultValue = [Position]()
    
    static func reduce(value: inout [Position], nextValue: () -> [Position]) {
        value.append(contentsOf: nextValue())
    }
}

private struct PositionIndicator: View {
    let type: PositionType
    
    var body: some View {
        GeometryReader { proxy in
            // the View itself is an invisible Shape that fills as much as possible
            Color.clear
            // Compute the top Y position and emit it to the Preferences queue
                .preference(key: PositionPreferenceKey.self, value: [Position(type: type, y: proxy.frame(in: .global).minY, x: proxy.frame(in: .global).minX)])
        }
    }
}

// Callback that'll trigger once refreshing is done
public typealias RefreshComplete = () -> Void
// The actual refresh action that's called once refreshing starts. It has the
// RefreshComplete callback to let the refresh action let the View know
// once it's done refreshing.
public typealias OnRefresh = (@escaping RefreshComplete) -> Void

// Tracks the state of the RefreshableScrollViewWithOffset - it's either:
// 1. waiting for a scroll to happen
// 2. has been primed by pulling down beyond THRESHOLD
// 3. is doing the refreshing.
private enum RefreshState {
    case waiting, primed, loading
}

public struct RefreshableScrollViewWithOffset<Content: View>: View {
    private var axis: Axis.Set
    private var showsIndicators: Bool
    private var verticalAlignment: VerticalAlignment
    private var horizontalAlignment: HorizontalAlignment
    private var spacing: CGFloat?
    private var pinnedViews: PinnedScrollableViews
    private var onRefresh: OnRefresh // the refreshing action
    private var onOffsetChange: ((CGFloat) -> Void)?
    private var content: Content // the ScrollView content
    
    @State private var state = RefreshState.waiting // the current state
    
    // The offset threshold. 50 is a good number, but you can play
    // with it to your liking.
    private var threshold: CGFloat = 50
    private var refreshViewLenght: CGFloat = 50
    
    // We use a custom constructor to allow for usage of a @ViewBuilder for the content
    public init(_ axis: Axis.Set = .vertical,
                showsIndicators: Bool = true,
                verticalAlignment: VerticalAlignment = .center,
                horizontalAlignment: HorizontalAlignment = .center,
                spacing: CGFloat? = nil,
                pinnedViews: PinnedScrollableViews = .init(),
                onRefresh: @escaping OnRefresh,
                onOffsetChange: ((CGFloat) -> Void)?,
                @ViewBuilder content: () -> Content) {
        self.axis = axis
        self.showsIndicators = showsIndicators
        self.verticalAlignment = verticalAlignment
        self.horizontalAlignment = horizontalAlignment
        self.spacing = spacing
        self.pinnedViews = pinnedViews
        self.onRefresh = onRefresh
        self.onOffsetChange = onOffsetChange
        self.content = content()
    }
    
    public var body: some View {
        // The root view is a regular ScrollView
        ScrollViewWithOffset(axis, showsIndicators: showsIndicators, verticalAlignment: verticalAlignment, horizontalAlignment: horizontalAlignment, spacing: spacing, pinnedViews: pinnedViews, onOffsetChange: onOffsetChange) {
            // The ZStack allows us to position the PositionIndicator,
            // the content and the loading view, all on top of each other.
            ZStack(alignment: axis == .vertical ? .top : .leading) {
                // The moving positioning indicator, that sits at the top
                // of the ScrollView and scrolls down with the content
                PositionIndicator(type: .moving)
                    .frame(height: 0)
                
                // Your ScrollView content. If we're loading, we want
                // to keep it below the loading view, hence the alignmentGuide.
                if axis == .vertical {
                    LazyVStack(alignment: horizontalAlignment, spacing: spacing, pinnedViews: pinnedViews) {
                        content
                    }
                    .alignmentGuide(.top, computeValue: { _ in
                        (state == .loading) ? -refreshViewLenght : 0
                    })
                } else {
                    LazyHStack(alignment: verticalAlignment, spacing: spacing, pinnedViews: pinnedViews) {
                        content
                    }
                    .alignmentGuide(.leading, computeValue: { _ in
                        (state == .loading) ? -refreshViewLenght : 0
                    })
                }
                
                
                // The loading view. It's offset to the top of the content unless we're loading.
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: axis == .vertical ? 0 : refreshViewLenght, height: axis == .vertical ? refreshViewLenght : 0)
                    if state == .loading {
                        ProgressView()
                    }
                }
                .offset(x: axis == .vertical ? 0 : (state == .loading) ? 0 : -refreshViewLenght, y: axis == .vertical ? (state == .loading) ? 0 : -refreshViewLenght : 0)
            }
        }
        // Put a fixed PositionIndicator in the background so that we have
        // a reference point to compute the scroll offset.
        .background(PositionIndicator(type: .fixed))
        // Once the scrolling offset changes, we want to see if there should
        // be a state change.
        .onPreferenceChange(PositionPreferenceKey.self) { values in
            if state != .loading { // If we're already loading, ignore everything
                // Map the preference change action to the UI thread
                DispatchQueue.main.async {
                    // Compute the offset between the moving and fixed PositionIndicators
                    var moving: CGFloat = 0
                    var fixed: CGFloat = 0
                    var offset: CGFloat = 0
                    
                    if axis == .vertical {
                        moving = values.first { $0.type == .moving }?.y ?? 0
                        fixed = values.first { $0.type == .fixed }?.y ?? 0
                        offset = moving - fixed
                    } else {
                        moving = values.first { $0.type == .moving }?.x ?? 0
                        fixed = values.first { $0.type == .fixed }?.x ?? 0
                        offset = moving - fixed
                    }
                    
                    // If the user pulled down below the threshold, prime the view
                    if offset > threshold && state == .waiting {
                        state = .primed
                        
                        // If the view is primed and we've crossed the threshold again on the
                        // way back, trigger the refresh
                    } else if offset < threshold && state == .primed {
                        withAnimation {
                            state = .loading
                        }
                        onRefresh { // trigger the refreshing callback
                            // once refreshing is done, smoothly move the loading view
                            // back to the offset position
                            withAnimation {
                                self.state = .waiting
                            }
                        }
                    }
                }
            }
        }
    }
}
