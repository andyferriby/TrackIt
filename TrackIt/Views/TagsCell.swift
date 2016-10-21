//
//  TagsCell.swift
//  TrackIt
//
//  Created by Jason Ji on 4/25/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit
import TagListView

let addTagTitle = "+ Add Tags"

class TagsCell: UITableViewCell {
    @IBOutlet weak var tagListView: TagListView!
    weak var delegate: TagsCellDelegate?
}

extension TagsCell: EntryConfigurable {
    func configureWithEntry(_ entry: Entry) {
        guard let tags = entry.tags else { return }
        tagListView.removeAllTags()
        tagListView.delegate = self
        let sortedTags = tags.allObjects.sorted { return ($0 as AnyObject).name < ($1 as AnyObject).name } as! [Tag]
        for tag in sortedTags {
            let tagView = tagListView.addTag(tag.name!)
            tagView.tagBackgroundColor = ColorManager.colorForIndex(Int(tag.colorIndex!))
            tagView.enableRemoveButton = true
            
        }        
        let addTagView = tagListView.addTag(addTagTitle)
        addTagView.tagBackgroundColor = UIColor.white
        addTagView.borderColor = UIColor.flatGreenColorDark()
        addTagView.borderWidth = 1.0
        addTagView.textColor = UIColor.flatGreenColorDark()
        addTagView.onTap = { tagView in
            self.delegate?.tagsCellDidTapAddTag?(self)
        }
        
        selectionStyle = .none
    }
}

extension TagsCell: TagConfigurable {
    func configureWithTags(_ tags: [Tag]) {
        tagListView.removeAllTags()
        tagListView.delegate = self
        for tag in tags {
            let tagView = tagListView.addTag(tag.name!)
            tagView.tagBackgroundColor = ColorManager.colorForIndex(Int(tag.colorIndex!))
            tagView.enableRemoveButton = true
        }
        selectionStyle = .none
    }
}

extension TagsCell: TagListViewDelegate {
    
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if title != addTagTitle {
            self.delegate?.tagsCell(self, didTapTagTitle: title)
        }
    }
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        self.delegate?.tagsCell(self, didTapRemoveButtonForTitle: title)
    }
}
