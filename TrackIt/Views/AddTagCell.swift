//
//  AddTagCell.swift
//  TrackIt
//
//  Created by Jason Ji on 4/27/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

@objc protocol AddTagCellDelegate {
    @objc func didAddTag(_ tag: String)
}

class AddTagCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField!
    weak var delegate: AddTagCellDelegate?
    
    @objc func configure(delegate: AddTagCellDelegate) {
        self.delegate = delegate
        textField.delegate = self
        textField.returnKeyType = .done
        selectionStyle = .none
    }
    
}

extension AddTagCell: UITextFieldDelegate {
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            if !text.isEmpty {
                delegate?.didAddTag(text.trimmingCharacters(in: CharacterSet.whitespaces))
                textField.text = nil
            }
        }
        textField.resignFirstResponder()
        return true
    }
    
}
