//
//  FilterTitleView.swift
//  TrackIt
//
//  Created by Jason Ji on 5/4/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit
import TagListView

@objc protocol FilterTitleViewDelegate {
    func closeViewTapped()
}

class FilterTitleView: UIView {
    @IBOutlet weak var dividerLineHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tagListView: TagListView!
    weak var delegate: FilterTitleViewDelegate?
    
    override func awakeFromNib() {
        dividerLineHeightConstraint.constant = 0.5
        
        tagListView.addTag("housing")
    }
    
    @IBAction func closePressed() {
        delegate?.closeViewTapped()
    }
}
