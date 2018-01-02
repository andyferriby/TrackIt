//
//  AddTagsTableViewController.swift
//  TrackIt
//
//  Created by Jason Ji on 4/26/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

@objc protocol AddTagsControllerDelegate {
    @objc func didFinishWithTags(_ tags: [Tag])
}

class AddTagsTableViewController: UITableViewController {

    lazy var model: AddTagsModel = AddTagsModel(context: context)

    @objc var context: NSManagedObjectContext = CoreDataStackManager.sharedInstance.managedObjectContext
    @objc var existingTags: [Tag]?
    @objc weak var delegate: AddTagsControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
        
        existingTags?.filter { $0.name != nil }.forEach { model.tryAddTag($0.name!) }
    }

    @IBAction func doneTapped(_ sender: UIBarButtonItem) {
        delegate?.didFinishWithTags(model.tags)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "New Tag"
        case 1: return "Selected Tags"
        case 2: return "All Tags"
        default: return nil
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return model.allTags.count == 0 ? 2 : 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return 1
        case 2: return model.allTags.count
        default: return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = identifierForRowAtIndexPath(indexPath)
        
        switch identifier {
            case "addTagCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! AddTagCell
            cell.configure(delegate: self)
            return cell
            
            case "selectedTagsCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TagsCell
            cell.configureWithTags(model.tags)
            cell.delegate = self
            return cell
            
            case "tagCell":
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TagCell
            let tag = model.allTags[(indexPath as NSIndexPath).row]
            cell.configureWithTag(tag, selected: model.containsTag(tag.name!))
            return cell
            
            default: return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let identifier = identifierForRowAtIndexPath(indexPath)
        if identifier == "tagCell" {
            model.didSelectTagAtIndex((indexPath as NSIndexPath).row)
            tableView.reloadData()
        }
    }
    
    @objc func identifierForRowAtIndexPath(_ indexPath: IndexPath) -> String {
        switch((indexPath as NSIndexPath).section) {
        case 0: return "addTagCell"
        case 1: return "selectedTagsCell"
        case 2: return "tagCell"
        default: return ""
        }
    }
}

extension AddTagsTableViewController: TagsCellDelegate {
    @objc func tagsCell(_ cell: TagsCell, didTapTagTitle title: String) {
        
    }
    @objc func tagsCell(_ cell: TagsCell, didTapRemoveButtonForTitle title: String) {
        model.removeTag(title)
        tableView.reloadData()
    }
    
}

extension AddTagsTableViewController: AddTagCellDelegate {
    @objc func didAddTag(_ tag: String) {
        model.tryAddTag(tag)
        tableView.reloadData()
    }
}
