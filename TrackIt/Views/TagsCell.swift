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
    func configureWithEntry(entry: Entry) {
        guard let tags = entry.tags else { return }
        tagListView.removeAllTags()
        tagListView.delegate = self
        let sortedTags = tags.allObjects.sort { return $0.name < $1.name } as! [Tag]
        for tag in sortedTags {
            let tagView = tagListView.addTag(tag.name!)
            tagView.tagBackgroundColor = ColorManager.colorForIndex(Int(tag.colorIndex!))
            tagView.enableRemoveButton = true
            
        }        
        let addTagView = tagListView.addTag(addTagTitle)
        addTagView.tagBackgroundColor = UIColor.flatGreenColor()
        addTagView.onTap = { tagView in
            self.delegate?.tagsCellDidTapAddTag?(self)
        }
        
        selectionStyle = .None
    }
}

extension TagsCell: TagConfigurable {
    func configureWithTags(tags: [Tag]) {
        tagListView.removeAllTags()
        tagListView.delegate = self
        for tag in tags {
            let tagView = tagListView.addTag(tag.name!)
            tagView.tagBackgroundColor = ColorManager.colorForIndex(Int(tag.colorIndex!))
            tagView.enableRemoveButton = true
        }
        selectionStyle = .None
    }
}

extension TagsCell: TagListViewDelegate {
    
    func tagPressed(title: String, tagView: TagView, sender: TagListView) {
        if title != addTagTitle {
            self.delegate?.tagsCell(self, didTapTagTitle: title)
        }
    }
    func tagRemoveButtonPressed(title: String, tagView: TagView, sender: TagListView) {
        self.delegate?.tagsCell(self, didTapRemoveButtonForTitle: title)
    }
}