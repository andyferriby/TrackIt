//
//  ImmobileCursorTextField.swift
//  TrackIt
//
//  Created by Jason Ji on 5/10/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

class ImmobileCursorTextField: UITextField {
    
    @objc var currencySymbol: String?
    
    // assume currencySymbol is always at position 0 with some length x
    
    override func closestPosition(to point: CGPoint) -> UITextPosition? {
        
        guard let currencySymbol = currencySymbol,
            let currentPosition = super.closestPosition(to: point)
            else { return super.closestPosition(to: point) }

        let currentPositionOffset = offset(from: beginningOfDocument, to: currentPosition)
        
        if currentPositionOffset <= currencySymbol.count {
            return position(from: beginningOfDocument, offset: currencySymbol.count)
        }
        else {
            return currentPosition
        }
        
    }
}
