//
//  EntryCell.swift
//  TrackIt
//
//  Created by Jason Ji on 4/29/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit
import TagListView
import DateTools
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class EntryCell: UITableViewCell {

    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

extension EntryCell: EntryConfigurable {
    @objc func configureWithEntry(_ entry: Entry, numberFormatter: NumberFormatter) {
        guard let amount = entry.amount,
                    let date = entry.date,
                    let note = entry.note else { return }
        
        amountLabel.text = numberFormatter.string(from: amount)
        amountLabel.textColor = Double(truncating: amount) >= 0 ? UIColor(red: 3/255.0, green: 166/255.0, blue: 120/255.0, alpha: 1.0) : UIColor.orange
        dateLabel.text = (date as NSDate).formattedDate(with: .short, locale: Locale.current)
        noteLabel.text = note
        
        if entry.tags?.count > 0, let tags = entry.tags?.allObjects as? [Tag] {
            tagListView.isHidden = false
            tagListView.removeAllTags()
            let sortedTags = tags.sorted { return $0.name < $1.name }
            for tag in sortedTags {
                let tagView = tagListView.addTag(tag.name!)
                tagView.tagBackgroundColor = ColorManager.colorForIndex(Int(truncating: tag.colorIndex!))
            }
        }
        else {
            tagListView.isHidden = true
        }
        
        self.editingAccessoryType = .disclosureIndicator
    }
}
