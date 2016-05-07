//
//  SelectTagsViewController.swift
//  TrackIt
//
//  Created by Jason Ji on 5/7/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit

protocol TagFilterDelegate {
    func didSelectTags(tags: [Tag])
}

class SelectTagsViewController: UIViewController {

    var delegate: TagFilterDelegate?
    
    override func viewDidLoad() {
        
    }
}
