//
//  FilterTitleView.swift
//  TrackIt
//
//  Created by Jason Ji on 5/4/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit
import TagListView

let preferredVerticalPadding: CGFloat = 14.0

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
    
    func preferredContentHeight() -> CGFloat {
        return tagListView.intrinsicContentSize().height + preferredVerticalPadding
    }
    
    func updateWithTags(tags: [Tag]) {
        tagListView.removeAllTags()
        for tag in tags {
            let tagView = tagListView.addTag(tag.name!)
            tagView.tagBackgroundColor = ColorManager.colorForIndex(Int(tag.colorIndex!))
        }
    }
}