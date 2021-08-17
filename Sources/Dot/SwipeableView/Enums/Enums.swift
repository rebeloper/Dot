//
//  Enums.swift
//  Dot
//
//  Created by Alex Nagy on 17.08.2021.
//

import SwiftUI

public enum SwipeableViewViewState: CaseIterable {
    case left
    case right
    case center
}

public enum SwipeableViewOnChangeSwipe {
    case leftStarted
    case rightStarted
    case noChange
}

public enum SwipeableViewActionSide: CaseIterable {
    case left
    case right
}

