//
//  AddTagCell.swift
//  TrackIt
//
//  Created by Jason Ji on 4/27/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

@objc protocol AddTagCellDelegate {
    func didAddTag(tag: String)
}

class AddTagCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    weak var delegate: AddTagCellDelegate?
    
    func configure(delegate delegate: AddTagCellDelegate) {
        self.delegate = delegate
        textField.delegate = self
        textField.returnKeyType = .Done
        selectionStyle = .None
    }
    
}

extension AddTagCell: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if let text = textField.text {
            if !text.isEmpty {
                delegate?.didAddTag(text)
                textField.text = nil
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
}