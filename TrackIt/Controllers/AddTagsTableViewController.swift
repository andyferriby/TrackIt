//
//  AddTagsTableViewController.swift
//  TrackIt
//
//  Created by Jason Ji on 4/26/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

@objc protocol AddTagsControllerDelegate {
    func didFinishAddingTags(tags: [Tag])
}

class AddTagsTableViewController: UITableViewController {

    let model = AddTagsModel()
    weak var delegate: AddTagsControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    @IBAction func doneTapped(sender: UIBarButtonItem) {
        delegate?.didFinishAddingTags(model.tags)
    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "New Tag"
        case 1: return "Selected Tags"
        case 2: return "All Tags"
        default: return nil
        }
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.allTags.count == 0 ? 2 : 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return model.allTags.count
        default: return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = identifierForRowAtIndexPath(indexPath)
        
        switch identifier {
            case "addTagCell":
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! AddTagCell
            cell.configure(delegate: self)
            return cell
            
            case "selectedTagsCell":
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath) as! TagsCell
            cell.configureWithTags(model.tags)
            cell.delegate = self
            return cell
            
            case "tagCell":
            let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)
            cell.configureWithModel(model, row: indexPath.row)
            return cell
            
            default: return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let identifier = identifierForRowAtIndexPath(indexPath)
        if identifier == "tagCell" {
            model.didSelectTagAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    func identifierForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        switch(indexPath.section) {
        case 0: return "addTagCell"
        case 1: return "selectedTagsCell"
        case 2: return "tagCell"
        default: return ""
        }
    }
}

extension AddTagsTableViewController: TagsCellDelegate {
    func tagsCell(cell: TagsCell, didTapTagTitle title: String) {
        
    }
    func tagsCell(cell: TagsCell, didTapRemoveButtonForTitle title: String) {
        model.removeTag(title)
        tableView.reloadData()
    }
    
}

extension AddTagsTableViewController: AddTagCellDelegate {
    func didAddTag(tag: String) {
        model.tryAddTag(tag)
        tableView.reloadData()
    }
}
