//
//  ImmobileCursorTextField.swift
//  TrackIt
//
//  Created by Jason Ji on 5/10/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

class ImmobileCursorTextField: UITextField {
    
    var currencySymbol: String?
    
    // assume currencySymbol is always at position 0 with some length x
    
    override func closestPositionToPoint(point: CGPoint) -> UITextPosition? {
        
        guard let currencySymbol = currencySymbol,
            currentPosition = super.closestPositionToPoint(point)
            else { return super.closestPositionToPoint(point) }

        let currentPositionOffset = offsetFromPosition(beginningOfDocument, toPosition: currentPosition)
        
        if currentPositionOffset <= currencySymbol.characters.count {
            return positionFromPosition(beginningOfDocument, offset: currencySymbol.characters.count)
        }
        else {
            return currentPosition
        }
        
    }
}
