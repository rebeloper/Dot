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
    
    /// The color for the outside
    /// - Parameter outsideColor: a UIColor
    public func outsideColor(_ outsideColor: UIColor) -> Self {
        var copy = self
        copy.outsideColor = outsideColor
        return copy
    }
    
    /// The opacity for the outside
    /// - Parameter outsideOpacity: a CGFloat between 0 and 1
    public func outsideOpacity(_ outsideOpacity: CGFloat) -> Self {
        var copy = self
        copy.outsideOpacity = outsideOpacity
        return copy
    }
    
    public func allowsDragToDismiss(_ allowsDragToDismiss: Bool) -> Self {
        var copy = self
        copy.allowsDraggingToDismiss = allowsDragToDismiss
        return copy
    }
    
    public func allowsTapOutsideToDismiss(_ allowsTapOutsideToDismiss: Bool) -> Self {
        var copy = self
        copy.allowsTapOutsideToDismiss = allowsTapOutsideToDismiss
        return copy
    }
    
    public func showsCloseButton(_ showsCloseButton: Bool) -> Self {
        var copy = self
        copy.showsCloseButton = showsCloseButton
        return copy
    }
    
    /// This is so we can drag the sheet up a bit
    /// - Parameter additionalOffset: a CGFloat
    public func additionalOffset(_ additionalOffset: CGFloat) -> Self {
        var copy = self
        copy.additionalOffset = additionalOffset
        return copy
    }
    
    /// Corner radius
    /// - Parameter cornerRadius: a CGFloat
    public func cornerRadius(_ cornerRadius: CGFloat) -> Self {
        var copy = self
        copy.cornerRadius = cornerRadius
        return copy
    }
    
}
