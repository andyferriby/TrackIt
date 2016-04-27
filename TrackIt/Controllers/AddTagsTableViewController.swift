//
//  AddTagsTableViewController.swift
//  TrackIt
//
//  Created by Jason Ji on 4/26/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

class AddTagsTableViewController: UITableViewController {

    let tags: [Tag] = {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Tag")
        let result = try? context.executeFetchRequest(fetchRequest) as! [Tag]
        return result ?? []
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "New Tag" : "All Tags";
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tags.count == 0 ? 1 : 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : tags.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = identifierForRowAtIndexPath(indexPath)
        let cell = tableView.dequeueReusableCellWithIdentifier(identifier, forIndexPath: indexPath)

        //...

        return cell
    }

    func identifierForRowAtIndexPath(indexPath: NSIndexPath) -> String {
        switch(indexPath.section) {
        case 0: return "addTagCell"
        case 1: return "tagCell"
        default: return ""
        }
    }

}
