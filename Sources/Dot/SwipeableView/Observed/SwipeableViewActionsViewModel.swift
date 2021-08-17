//
//  SwipeableViewActionsViewModel.swift
//  Dot
//
//  Created by Alex Nagy on 17.08.2021.
//

import SwiftUI

open class SwipeableViewActionsViewModel: ObservableObject {
    
    let actions: [SwipeableViewAction]
    
    public init(_ actions: [SwipeableViewAction],
                maxActions: Int) {
        self.actions = Array(actions.prefix(maxActions))
    }
}
