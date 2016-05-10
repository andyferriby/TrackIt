//
//  ManageTagsViewController.swift
//  TrackIt
//
//  Created by Jason Ji on 5/9/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class ManageTagsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var dividerHeightConstraint: NSLayoutConstraint!
    
    var coreDataManager: CoreDataStackManager?
    let emptyDataSetDataSource = EmptyDataSetDataSource(title: "No Tags", dataSetDescription: "Add some tags the next time you add an entry.", verticalOffset: -22.0)
    
    lazy var fetchedResultsController: NSFetchedResultsController? = { [unowned self] in
        guard let context = self.coreDataManager?.managedObjectContext else { return nil }
        let fetchRequest = NSFetchRequest(entityName: "Tag")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try controller.performFetch()
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
        controller.delegate = self
        return controller
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 44.0
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
        tableView.emptyDataSetSource = emptyDataSetDataSource
        tableView.emptyDataSetDelegate = self
        
        tableView.editing = true
        dividerHeightConstraint.constant = 0.5
    }
}

extension ManageTagsViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.configureWithTag(tag, selected: false)
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, willBeginEditingRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let tag = fetchedResultsController?.objectAtIndexPath(indexPath) as! Tag
        NSNotificationCenter.defaultCenter().postNotificationName("TagWillBeDeleted", object: self, userInfo: ["name":tag.name!])
        coreDataManager?.managedObjectContext.deleteObject(tag)
        coreDataManager?.save()
        NSNotificationCenter.defaultCenter().postNotificationName("TagWasDeleted", object: self)
    }
}

extension ManageTagsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        guard let indexPath = indexPath else { return }
        switch type {
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        default: break
        }
    }
}

extension ManageTagsViewController: DZNEmptyDataSetDelegate {
    func emptyDataSetWillAppear(scrollView: UIScrollView!) {
        warningView.hidden = true
    }
    func emptyDataSetWillDisappear(scrollView: UIScrollView!) {
        warningView.hidden = false
    }
}