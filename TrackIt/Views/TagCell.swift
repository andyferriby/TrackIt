//
//  TagCell.swift
//  TrackIt
//
//  Created by Jason Ji on 5/8/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

class TagCell: UITableViewCell {

    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let backgroundColor = dotView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        dotView.backgroundColor = backgroundColor
    }

}

extension TagCell: TagConfigurable {
    @objc func configureWithTag(_ tag: Tag, selected: Bool) {
        label.text = tag.name!
        dotView.backgroundColor = ColorManager.colorForIndex(Int(truncating: tag.colorIndex!))
        dotView.layer.cornerRadius = 4.0
        accessoryType = selected ? .checkmark : .none
    }
}
