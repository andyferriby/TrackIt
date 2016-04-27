//
//  TagsCell.swift
//  TrackIt
//
//  Created by Jason Ji on 4/25/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit
import TagListView

let addTagTitle = "+ Add Tag"

class TagsCell: UITableViewCell {
    @IBOutlet weak var tagListView: TagListView!
    weak var delegate: TagsCellDelegate?
}

extension TagsCell: Configurable {
    func configureWithEntry(entry: Entry) {
        guard let tags = entry.tags else { return }
        let sortedTags = tags.allObjects.sort { return $0.name < $1.name }
        for tag in sortedTags {
            let tagView = tagListView.addTag(tag.name)
            tagView.enableRemoveButton = true
            
        }
        
        tagListView.delegate = self
        
        let foo = tagListView.addTag("Foo")
        foo.enableRemoveButton = true
        
        let addTagView = tagListView.addTag(addTagTitle)
        addTagView.backgroundColor = UIColor.orangeColor()
        addTagView.onTap = { tagView in
            self.delegate?.tagsCellDidTapAddTag(self)
        }
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