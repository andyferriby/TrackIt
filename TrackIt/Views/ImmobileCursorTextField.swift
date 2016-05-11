//
//  ImmobileCursorTextField.swift
//  TrackIt
//
//  Created by Jason Ji on 5/10/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

class ImmobileCursorTextField: UITextField {
    
    override func closestPositionToPoint(point: CGPoint) -> UITextPosition? {
        return super.endOfDocument
    }
    
}
