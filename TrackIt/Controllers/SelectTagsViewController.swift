//
//  SelectTagsViewController.swift
//  TrackIt
//
//  Created by Jason Ji on 5/7/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

@objc protocol TagFilterDelegate {
    func didSelectTags(tags: [Tag])
}

class SelectTagsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var delegate: TagFilterDelegate?
    var managedObjectContext: NSManagedObjectContext?
    var selectedTags: [Tag] = []
    
    lazy var fetchedResultsController: NSFetchedResultsController? = { [unowned self] in
        guard let context = self.managedObjectContext else { return nil }
        let fetchRequest = NSFetchRequest(entityName: "Tag")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
           try controller.performFetch()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }
    // TODO: DZNEmptyDataSetDelegate
}

extension SelectTagsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fetchedResultsController?.sections?.count > 0 {
            return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tag = fetchedResultsController?.objectAtIndexPath(indexPath) as! Tag
        let cell = tableView.dequeueReusableCellWithIdentifier("tagCell", forIndexPath: indexPath) as! TagCell
        cell.configureWithTag(tag, selected: selectedTags.contains(tag) ?? false)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tag = fetchedResultsController?.objectAtIndexPath(indexPath) as! Tag
        if let index = selectedTags.indexOf(tag) {
            selectedTags.removeAtIndex(index)
        }
        else {
            selectedTags.append(tag)
        }
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
        delegate?.didSelectTags(selectedTags)
    }
}