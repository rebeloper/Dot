//
//  FlexibleSheet+.swift
//  dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

extension FlexibleSheet {
    
    /// The proportion of the containing view's height to use for the height of the FlexibleSheet
    /// - Parameter height: a FlexibleSheetHeight case - either .fixed(required height in pixels) or .proportional(proportion of the containing view's height - 1 is 100% of the height)
    public func height(_ height: FlexibleSheetHeight) -> Self {
        var copy = self
        copy.height = height
        return copy
    }
    
    /// Insets to use around the content of the FlexibleSheet
    /// - Parameter contentInsets: an EdgeInsets instance
    public func contentInsets(_ contentInsets: EdgeInsets) -> Self {
        var copy = self
        copy.contentInsets = contentInsets
        return copy
    }
    
    /// The background colour for the FlexibleSheet
    /// - Parameter backgroundColor: a UIColor
    public func backgroundColor(_ backgroundColor: UIColor) -> Self {
        var copy = self
        copy.backgroundColor = backgroundColor
        return copy
    }
    
    /// The color for the close button
    /// - Parameter closeButtonColor: a UIColor
    public func closeButtonColor(_ closeButtonColor: UIColor) -> Self {
        var copy = self
        copy.closeButtonColor = closeButtonColor
        return copy
    }
    
    public func disableDragToDismiss(_ disableDragToDismiss: Bool) -> Self {
        var copy = self
        copy.allowsDraggingToDismiss = !disableDragToDismiss
        return copy
    }
    
    public func disableTapBackgroundToDismiss(_ disableTapBackgroundToDismiss: Bool) -> Self {
        var copy = self
        copy.allowsTapBackgroundToDismiss = !disableTapBackgroundToDismiss
        return copy
    }
    
    public func showsCloseButton(_ showsCloseButton: Bool) -> Self {
        var copy = self
        copy.showsCloseButton = showsCloseButton
        return copy
    }
    
}
